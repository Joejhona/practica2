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

;Convirtiendo a UTM las coordenadas
xy_total    = latlon2utm((/file_hgt(:,1),file_hgt(:,0)/),2)

;16 san pedro 9:30 
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Preparando plot 
;type        = "png"
type        = "x11"
titulo1     = "batimetria"
wks         = gsn_open_wks(type,titulo1)
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Alistando los detalles
;¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
;----- Extraendo y ploteando datos wrf
res                     = True      ;--> activa los detalles
res@gsnDraw             = True     ;---> Para no superponer
res@gsnFrame            = True     ;---> Para ver una por una 
res@gsnMaximize         = True
;res@tiMainString        = "GPCP 1DD V1.2 Combined Data Sets"
;res@gsnLeftString       = ""        ;time_str
;res@gsnAddCyclic        = False     ;--> Necesario datos ciclicos
;---Grid Text--Grilla---;
res@gsnMajorLatSpacing  = 2
res@gsnMajorLonSpacing  = 2
res@tmYLLabelStride     = 1
res@tmXBLabelStride     = 1
;-------Limites del Mapa--------;     
res@mpLimitMode         = "Corners" ;--> Activa limites modo corners
res@mpLeftCornerLatF    = lat_min   ;--> limites.ncl r=rimac p=Perú   
res@mpRightCornerLatF   = lat_max   ;--> n=Norte
res@mpLeftCornerLonF    = lon_min
res@mpRightCornerLonF   = lon_max
;---Limites Nacionales---;
res@mpOutlineBoundarySets       = "National"    ;---> Limite de Paises
res@mpNationalLineThicknessF    = 2             ;---> Grosor de linea nacional
res@mpGeophysicalLineThicknessF = 2             ;---> Grosor de linea continental
;---Grid--Grilla---;
res@mpGridAndLimbOn     = True
res@mpGridLatSpacingF   = 0.5
res@mpGridLonSpacingF   = 0.5
res@mpGridLineColor     = "Gray30"
;---Estilo de los datos---;
res@cnFillOn            = True
res@cnFillPalette       = "GMT_copper"
;res@cnLinesOn           = False             ;---> Contorno de linea (falso = no)
res@cnLineLabelsOn      = False
;res@lbLabelBarOn        = False     ;True   ;---> desactiva la paleta individual
;res@cnLevelSelectionMode= "ExplicitLevels"  ;---> Solo usa los indicados en levels
;res@cnLevels            = levels

plot = gsn_csm_contour_map(wks,bat_new,res)

end