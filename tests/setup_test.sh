#!/usr/bin/env bash
# shellcheck disable=SC2030,SC2031

set -euo pipefail

TEST_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
readonly TEST_ROOT
test_home="$(mktemp -d)"
test_bin="$(mktemp -d)"
bootstrap_checkout="$(mktemp -d)"
oh_my_zsh_home="$(mktemp -d)"
trap 'rm -rf "$test_home" "$test_bin" "$bootstrap_checkout" "$oh_my_zsh_home"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

oh_my_zsh_output="$oh_my_zsh_home/output"
(
  export HOME="$oh_my_zsh_home"
  export SETUP_DRY_RUN=1
  export SETUP_ROOT="$TEST_ROOT"
  source "$TEST_ROOT/lib/setup/common.sh"
  source "$TEST_ROOT/lib/setup/phases/packages.sh"
  setup_oh_my_zsh
) >"$oh_my_zsh_output"
oh_my_zsh_dry_run="$(<"$oh_my_zsh_output")"
printf '%s\n' "$oh_my_zsh_dry_run" | grep -q 'github.com/ohmyzsh/ohmyzsh.git' ||
  fail "Oh My Zsh clone was missing from a clean dry run"

cat >"$test_bin/brew" <<'BREW'
#!/usr/bin/env bash
printf '%s\n' "$*"
BREW
chmod +x "$test_bin/brew"

export HOME="$test_home"
export PATH="$test_bin:/usr/bin:/bin:/usr/sbin:/sbin"

printf 'existing zsh configuration\n' >"$HOME/.zshrc"
mkdir -p "$HOME/.config"
ln -s "$TEST_ROOT/config/fish" "$HOME/.config/fish"
ln -s "$TEST_ROOT/config/starship.toml" "$HOME/.config/starship.toml"
ln -s "$TEST_ROOT/config/tmux" "$HOME/.config/tmux"

"$TEST_ROOT/bin/setup" home --only preflight,dotfiles >/dev/null
[[ -L "$HOME/.zshrc" ]] || fail ".zshrc was not linked"
[[ "$(readlink "$HOME/.zshrc")" == "$TEST_ROOT/config/zshrc" ]] ||
  fail ".zshrc points to the wrong source"
[[ "$(readlink "$HOME/.zprofile")" == "$TEST_ROOT/config/zprofile" ]] ||
  fail ".zprofile points to the wrong source"
[[ "$(readlink "$HOME/.config/mise/config.toml")" == "$TEST_ROOT/config/mise/home.toml" ]] ||
  fail "Mise points to the wrong profile configuration"
find "$HOME/.local/state/setup/backups" -name .zshrc -type f -print -quit | grep -q . ||
  fail "conflicting .zshrc was not backed up"
for obsolete_link in fish starship.toml tmux; do
  [[ ! -L "$HOME/.config/$obsolete_link" ]] ||
    fail "obsolete $obsolete_link link was not removed"
done

for command_name in nvim trash zoxide aerospace mise node; do
  ln -s /usr/bin/true "$test_bin/$command_name"
done
mkdir -p "$HOME/.oh-my-zsh"
git -C "$HOME/.oh-my-zsh" init -q
git -C "$HOME/.oh-my-zsh" remote add origin https://github.com/ohmyzsh/ohmyzsh.git
printf '# test Oh My Zsh init\n' >"$HOME/.oh-my-zsh/oh-my-zsh.sh"
"$TEST_ROOT/bin/setup-doctor" home >/dev/null ||
  fail "doctor rejected a correctly linked test home"

second_run="$("$TEST_ROOT/bin/setup" home --only preflight,dotfiles)"
if printf '%s\n' "$second_run" | grep -q 'mv '; then
  fail "second dotfile run attempted a mutation"
fi

home_packages="$("$TEST_ROOT/bin/setup" home --dry-run --only packages)"
printf '%s\n' "$home_packages" | grep -q 'Brewfile.home' ||
  fail "home profile did not select Brewfile.home"
printf '%s\n' "$home_packages" | grep -q 'config/mise/home.toml' ||
  fail "home profile did not select its Mise configuration"
printf '%s\n' "$home_packages" | grep -q 'Oh My Zsh is installed' ||
  fail "package setup did not check Oh My Zsh"
if printf '%s\n' "$home_packages" | grep -q 'Brewfile.work'; then
  fail "home profile selected Brewfile.work"
fi

work_packages="$("$TEST_ROOT/bin/setup" work --dry-run --only packages)"
printf '%s\n' "$work_packages" | grep -q 'Brewfile.work' ||
  fail "work profile did not select Brewfile.work"
printf '%s\n' "$work_packages" | grep -q 'config/mise/work.toml' ||
  fail "work profile did not select its Mise configuration"

if "$TEST_ROOT/bin/setup" home --only unknown >/dev/null 2>&1; then
  fail "unknown setup phase was accepted"
fi
"$TEST_ROOT/bin/setup" --help >/dev/null || fail "setup help failed"
"$TEST_ROOT/bin/setup-doctor" --help >/dev/null || fail "doctor help failed"

postflight="$("$TEST_ROOT/bin/setup" home --only postflight)"
printf '%s\n' "$postflight" | grep -q 'PASS.*0 failure(s)' ||
  fail "postflight did not run setup-doctor successfully"

for command_name in java gradle terraform; do
  ln -s /usr/bin/true "$test_bin/$command_name"
done
"$TEST_ROOT/bin/setup" work --only dotfiles >/dev/null
[[ "$(readlink "$HOME/.config/mise/config.toml")" == "$TEST_ROOT/config/mise/work.toml" ]] ||
  fail "Mise did not switch to the work profile configuration"
"$TEST_ROOT/bin/setup-doctor" work >/dev/null ||
  fail "doctor rejected a correctly linked work profile"

safe_defaults="$(SETUP_ROOT="$TEST_ROOT" "$TEST_ROOT/config/osx/config" --dry-run)"
if printf '%s\n' "$safe_defaults" | grep -q 'persistent-apps'; then
  fail "safe macOS defaults clear the Dock"
fi

opinionated_defaults="$(SETUP_ROOT="$TEST_ROOT" "$TEST_ROOT/config/osx/config" --dry-run --opinionated)"
printf '%s\n' "$opinionated_defaults" | grep -q 'persistent-apps' ||
  fail "opinionated macOS defaults do not clear the Dock"

macos_fixture="$test_home/macos-fixture"
mkdir -p "$macos_fixture"
ln -s "$TEST_ROOT/config" "$macos_fixture/config"
for command_name in defaults osascript killall; do
  ln -s /usr/bin/true "$test_bin/$command_name"
done
for opinionated in 0 1; do
  (
    export SETUP_ROOT="$macos_fixture"
    export SETUP_DRY_RUN=0
    export SETUP_OPINIONATED="$opinionated"
    source "$TEST_ROOT/lib/setup/common.sh"
    source "$TEST_ROOT/lib/setup/phases/macos.sh"
    setup_phase_macos >/dev/null
  ) || fail "macOS phase failed with opinionated=$opinionated"
done

xcode_state="$test_home/xcode-installed"
export XCODE_TEST_STATE="$xcode_state"
cat >"$test_bin/xcode-select" <<'XCODE_SELECT'
#!/usr/bin/env bash
if [[ "$1" == "-p" ]]; then
  [[ -f "$XCODE_TEST_STATE" ]]
elif [[ "$1" == "--install" ]]; then
  : >"$XCODE_TEST_STATE"
else
  exit 2
fi
XCODE_SELECT
chmod +x "$test_bin/xcode-select"

mkdir -p "$bootstrap_checkout/bin"
git -C "$bootstrap_checkout" init -q
git -C "$bootstrap_checkout" remote add origin https://github.com/tom-delalande/setup.git
cat >"$bootstrap_checkout/bin/setup" <<'BOOTSTRAP_SETUP'
#!/usr/bin/env bash
printf 'bootstrap continued with %s\n' "$*"
BOOTSTRAP_SETUP
chmod +x "$bootstrap_checkout/bin/setup"

bootstrap_output="$(SETUP_DIRECTORY="$bootstrap_checkout" "$TEST_ROOT/bootstrap.sh" home --include-opinionated)"
printf '%s\n' "$bootstrap_output" | grep -q 'bootstrap continued with home --include-opinionated' ||
  fail "bootstrap did not continue after Command Line Tools installation"

printf 'All setup tests passed.\n'
