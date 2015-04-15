
function Get-ClipboardText {
  add-type -an system.windows.forms
  [System.Windows.Forms.Clipboard]::GetText()
}

set-alias paste Get-ClipboardText

set-alias pbpaste Get-ClipboardText
set-alias pbcopy clip
