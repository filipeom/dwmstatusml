let time () =
  let time = Unix.gettimeofday () in
  Unix.localtime time

let pp fmt tm =
  let min = tm.Unix.tm_min in
  let hour = tm.Unix.tm_hour in
  let month =
    match tm.Unix.tm_mon with
    | 0 -> "Jan"
    | 1 -> "Feb"
    | 2 -> "Mar"
    | 3 -> "Apr"
    | 4 -> "May"
    | 5 -> "Jun"
    | 6 -> "Jul"
    | 7 -> "Aug"
    | 8 -> "Sep"
    | 9 -> "Oct"
    | 10 -> "Nov"
    | 11 -> "Dec"
    | _ -> assert false
  in
  let day = tm.Unix.tm_mday in
  let weekday =
    match tm.Unix.tm_wday with
    | 0 -> "Sunday"
    | 1 -> "Monday"
    | 2 -> "Tuesday"
    | 3 -> "Wednesday"
    | 4 -> "Thursday"
    | 5 -> "Friday"
    | 6 -> "Saturday"
    | _ -> assert false
  in
  Format.fprintf fmt "%s %02d %s %02d:%02d" weekday day month hour min
