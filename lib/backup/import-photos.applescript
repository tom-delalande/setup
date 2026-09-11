on run mediaPaths
	set mediaFiles to {}
	repeat with mediaPath in mediaPaths
		set end of mediaFiles to (POSIX file mediaPath)
	end repeat

	tell application "Photos"
		-- Photos performs its own duplicate check when this is false.
		import mediaFiles skip check duplicates false
	end tell
end run
