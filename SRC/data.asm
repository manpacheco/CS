; 8000 a 810A
Cities: db 255,"Headquarters",255,"New York",255,"Montreal",255,"Mexico City",255,"Lima",255,"Rio de Janeiro",255,"Buenos Aires",255,"Reykjavik",255,"London",255,"Paris",255,"San Marino",255,"Rome",255,"Oslo",255,"Budapest",255,"Athens",255,"Istanbul",255,"Moscow",255,"Baghdad",255,"Cairo",255, "Bamako",255, "Kigali",255, "Moroni",255, "Kathmandu",255,"New Delhi",255,"Colombo",255,"Peking",255,"Tokyo",255,"Bangkok",255,"Singapore",255,"Port Moresby",255,"Sydney",255

; 810B a 81F1
Countries: db 255,"-",255,"USA",255,"Canada",255,"Mexico",255,"Peru",255,"Brazil",255,"Argentina",255,"Iceland",255,"UK",255,"France",255,"San Marino",255,"Italy",255,"Norway",255,"Hungary",255,"Greece",255,"Turkey",255,"Soviet Union",255,"Iraq",255,"Egypt",255,"Mali",255,"Rwanda",255,"Comoros",255,"Nepal",255,"India",255,"Sri Lanka",255,"China",255,"Japan",255,"Thailand",255,"Singapore",255,"Papua New Guinea",255,"Australia",255

Nombres: db "Carmen Sandiego", "Merey LaRoc", "Dazzle Annie", "Lady Aqatha", "Len Bulk", "Scar Graynolt", "Nick Brunch", "Fast Eddie B", "Ihor Ihorovich", "Katherine Drib"
Sex: db 'F', 'F', 'F', 'F', 'M', 'M', 'M', 'M', 'M', 'M'

;Tablas maestras
Hobby: db "tennis","music","mt. climbing","skydiving","swimming","croquet"
Hair: db "brown", "blond", "red", "black"
Feature: db "limps", "ring", "tatto", "scar", "jewelry"
Vehicle: db "convertible", "limousine", "race car", "motorcycle"
Weekdays: db "Mon", 255,"Tue",255,"Wed",255,"Thu",255,"Fri",255,"Sat",255,"Sun",255

;Estado actual
Suspect: db 99
Screen_source_address_offset db 0
CurrentCity: db 1 ; rango [1,31]
CurrentCountry: db 28
CurrentWeekday: db 3 ; EMPIEZA EN 1
CurrentHour: db "09:00",255

;1234567890123412345678901234123456789012341234567890123412345678901234123456789012341234567890123412345678901234123456789012341234567890123412345678901234123456789012341234567890123412345678901234
;Argentina is South America's second-largest nation, after Brazil. Its terrain ranges from tropical forests in the north to cold and barren Tierra del Fuego in the south.
;Budapest, the capital of Hungary, was once two cities - Buda and Pest - separated by the Danube River.
;Rio de Janeiro is Brazil's second-largest city. Famous Sugar Loaf peak overlooks its beautiful natural harbor.
;Colombo, with a population of more than 1.2 million, is the capital and principal city of Sri Lanka, an island nation located off the southeast coast of India.
;Peking is the capital of the People's Republic of China. One of this nation's most famous landmarks is the Great Wall.
;Until the 15th century, Mali was part of the great Mali Empire. Its ancient city of Timbuktu was an important center of Islamic study.
;Hungary, with an area slightly smaller than Indiana, is bordered by Czechoslovakia, Austria, Yugoslavia, Romania and the Soviet Union.

;;; 12x16
;; 32x24
;;8x12 (6 pantallas por SCR) = 5 SCR

;16*8/12
;16*2/3
;32/3 = 10.66

; ventana derecha 14x14 caracteres ancho


;24 alto /2 = 12 caracteres alto =  12*8 = 96

;32 ancho /3 = 10 caracteres ancho = 80

;libre : 24 * 2 = 48 caracteres