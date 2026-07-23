Set-PSReadLineOption -EditMode Vi

function g { git status --short }
function gd { git diff }
function gds { git diff --staged }
function n { if ($args) { nvim $args } else { nvim -S }}
function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

Set-Alias l ls
