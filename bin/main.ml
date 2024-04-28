open Xlib

let set_status dpy msg =
  xStoreName ~dpy ~win:(xDefaultRootWindow ~dpy) ~name:msg;
  xSync ~dpy ~discard:false

let () =
  let dpy = open_display () in
  set_status dpy "Hello, World!";
  xCloseDisplay ~dpy
