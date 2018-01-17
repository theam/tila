function openNewFile() {
  swal({
    title: "You will be now redirected to the 'Create new file' page in the TIL repo",
    text: "Remember:\n\nFirst line must be your name\n\nSecond line must be blank\n\nWrite your content using markdown after that.\n\nSave that into a category directory like 'unix/echo-prints-stuff.md'\n\n(ESC to close this dialog)",
    icon: "info",
    dangerMode: true
  }, (value) => {
    if(value) window.location.href = "https://github.com/theam/til/new/master";
  });
}

hljs.initHighlightingOnLoad()