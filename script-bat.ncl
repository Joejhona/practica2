begin

file_bat    = "xyz01.txt"
file_lc     = "LC.txt"

file_bat   := asciiread(file_bat,(/125,3/),"float")
file_lc    := asciiread(file_lc,(/199,3/),"float")

file_hgt    = array_append_record(file_bat, file_lc, 0)

lat_max     = max(file_hgt(:,1))
lat_min     = min(file_hgt(:,1))
lon_max     = max(file_hgt(:,0))
lon_min     = min(file_hgt(:,0))

xy1_utm     = latlon2utm((/lat_max,lon_max/),2)
xy2_utm     = latlon2utm((/lat_min,lon_min/),2)

xy_lat      = round(((xy1_utm-xy2_utm)/500),3)+1



end