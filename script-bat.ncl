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

;xy_lat      = round(((xy1_utm-xy2_utm)/500),3)+1
xy_latlon   = toint(ceil((xy1_utm-xy2_utm)/500))   ;---> redondeando al maximo
lat_new     = fspan(lat_min,lat_max,xy_latlon(0))
lon_new     = fspan(lon_min,lon_max,xy_latlon(1)) 

bat_new     = natgrid(file_hgt(:,1),file_hgt(:,0),file_hgt(:,2)*-1,lat_new,lon_new)
bat_new!0                = "latitude"        ;--->rotulo lat
bat_new!1                = "longitude"       ;--->rotulo lon 
bat_new&latitude         = lat_new            
bat_new&longitude        = lon_new
bat_new&latitude@units   = "degrees_north"   ;--->und lat
bat_new&longitude@units  = "degrees_east"    ;--->und lon

xy_total    = latlon2utm((/file_hgt(:,1),file_hgt(:,0)/),2)



end