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

;bat_new     = natgrid(file_hgt(:,1),file_hgt(:,0),file_hgt(:,2)*-1,lat_new,lon_new)
bat_new     = natgrid(file_hgt(:,0),file_hgt(:,1),file_hgt(:,2)*-1,lon_new,lat_new)
bat_new    := transpose(bat_new)
bat_new!0                = "latitude"        ;--->rotulo lat
bat_new!1                = "longitude"       ;--->rotulo lon 
bat_new&latitude         = lat_new            
bat_new&longitude        = lon_new
bat_new&latitude@units   = "degrees_north"   ;--->und lat
bat_new&longitude@units  = "degrees_east"    ;--->und lon
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Preparando plot 
type        = "png"
;type        = "x11"
titulo1     = "Batimetria-Sechura"
wks         = gsn_open_wks(type,titulo1)
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Alistando los detalles
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Extraendo y ploteando datos wrf
res                     = True      ;--> activa los detalles
res@gsnMaximize         = True
res@tiMainString        = "Batimetria de la bahia de Sechura en Piura"
res@gsnRightString      = "metros"        ;time_str
res@gsnAddCyclic        = False     ;--> Necesario datos ciclicos
;-------Limites del Mapa--------;     
res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
res@mpLeftCornerLatF    = lat_min   ;--> limites.ncl r=rimac p=Perú   
res@mpRightCornerLatF   = lat_max   ;--> n=Norte
res@mpLeftCornerLonF    = lon_min
res@mpRightCornerLonF   = lon_max
;---Grid--Grilla---;
res@mpGridAndLimbOn     = True
res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
;---Estilo de los datos---;
res@cnLinesOn           = True             ;---> Contorno de linea (falso = no)
res@cnLineLabelsOn      = True
res@cnFillOn            = True
res@lbOrientation       ="vertical"
res@cnFillPalette       = "GMT_copper"
res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
res@cnMinLevelValF      = -160.			; set the minimum contour level
res@cnMaxLevelValF      = 0.			; set the maximum contour level
res@cnLevelSpacingF     = 10.			; set the interval between contours


plot = gsn_csm_contour_map(wks,bat_new,res)

;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- escribiendo en ascii
nlat  = xy_latlon(0)
mlon  = xy_latlon(1)
npts  = nlat*mlon        ; total number of grid points
data  = new(npts,string)
npt   = -1
do nl=0,nlat-1          
  do ml=0,mlon-1
    npt  = npt + 1     
    xy_utm   := latlon2utm((/bat_new&latitude(nl),bat_new&longitude(ml)/),2)
    data(npt) = sprintf("%7.5f ",xy_utm(0))
    data(npt) = data(npt) + sprintf("%7.5f ",xy_utm(1))
    data(npt) = data(npt) + sprintf("%10.7f",bat_new(nl,ml))
  end do
end do
asciiwrite(titulo1+".csv", data)

end