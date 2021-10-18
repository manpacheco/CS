; 8000 a 810A
;Cities: db 255,"Headquarters",255,"New York",255,"Montreal",255,"Mexico City",255,"Lima",255,"Rio de Janeiro",255,"Buenos Aires",255,"Reykjavik",255,"London",255,"Paris",255,"San Marino",255,"Rome",255,"Oslo",255,"Budapest",255,"Athens",255,"Istanbul",255,"Moscow",255,"Baghdad",255,"Cairo",255, "Bamako",255, "Kigali",255, "Moroni",255, "Kathmandu",255,"New Delhi",255,"Colombo",255,"Peking",255,"Tokyo",255,"Bangkok",255,"Singapore",255,"Port Moresby",255,"Sydney",255
Cities: db 255,"Headquarters",255,"Athens",255,"Baghdad",255,"Bamako",255,"Bangkok",255,"Budapest",255,"Buenos Aires",255,"Cairo",255,"Colombo",255,"Istanbul",255,"Kathmandu",255,"Kigali",255,"Lima",255,"London",255,"Mexico City",255,"Montreal",255,"Moroni",255,"Moscow",255,"New Delhi",255,"New York",255,"Oslo",255,"Paris",255,"Peking",255,"Port Moresby",255,"Reykjavik",255,"Rio de Janeiro",255,"Rome",255,"San Marino",255,"Singapore",255,"Sydney",255,"Tokyo",255

; 810B a 81F1
;Countries: db 255,"-",255,"USA",255,"Canada",255,"Mexico",255,"Peru",255,"Brazil",255,"Argentina",255,"Iceland",255,"UK",255,"France",255,"San Marino",255,"Italy",255,"Norway",255,"Hungary",255,"Greece",255,"Turkey",255,"Soviet Union",255,"Iraq",255,"Egypt",255,"Mali",255,"Rwanda",255,"Comoros",255,"Nepal",255,"India",255,"Sri Lanka",255,"China",255,"Japan",255,"Thailand",255,"Singapore",255,"Papua New Guinea",255,"Australia",255
Countries: db 255,"-",255,"Greece",255,"Iraq",255,"Mali",255,"Thailand",255,"Hungary",255,"Argentina",255,"Egypt",255,"Sri Lanka",255,"Turkey",255,"Nepal",255,"Rwanda",255,"Peru",255,"UK",255,"Mexico",255,"Canada",255,"Comoros",255,"Soviet Union",255,"India",255,"USA",255,"Norway",255,"France",255,"China",255,"Papua New Guinea",255,"Iceland",255,"Brazil",255,"Italy",255,"San Marino",255,"Singapore",255,"Australia",255,"Japan",255

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
;Screen_source_address_offset db 0 ; 0/10/20
Aux_screen_horizontal_offset db 0 ; 0/10/20
Aux_screen_vertical_offset db 0 ; 0/128
CurrentCity: db 3 ; rango [1,30]
CurrenCityConfigOffsetX db 0,10,20,0,10,20
CurrenCityConfigOffsetY db 0,0,0,128,128,128
CurrentCountry: db 28
CurrentWeekday: db 3 ; EMPIEZA EN 1
CurrentHour: db "09:00",255

;City_descriptions: db "Welcome to Athens, the capital of Greece, and home of the famous Parthenon",255,"Iraq's neighbors are Jordan, Syria, Turkey, Iran, Kuwait and Saudi Arabia",255,"Bamako is the capital of Mali. This country is also the site of the ancient desert outpost of Timbuktu",255,"Welcome to Bangkok, the capital of Thailand. Bangkok is laced with canals and dotted with pagodas",255,"Budapest, with a population of 2 million, was once two cities, Buda and Pest, separated by the Danube River",255,"The fertile Pampas, or plains, region in central Argentina provides an abundance of beef and grain",255,"Cairo, with a population of more than 5 million, is the largest city in Africa",255,"Welcome to Colombo, the capital of Sri Lanka, a mountainous island nation off the southeast coast of India",255,"Turkey, which has hot dry summers and cold winters, is ringed by mountains on all but the western border",255,"Welcome to Kathmandu, the capital of Nepal, located high in the Himalayas",255,"Rwanda is a country of lush jungle terrain, and the home of rare mountain gorillas",255,"Welcome to Lima, the capital of Peru. This Andean nation was once the center of the Incan empire",255,"London is the capital of the United Kingdom, which consists of England, Scotland, Wales and Northern Ireland",255,"Mexico was the site of the advanced Indian civilizations of the Mayans, the Toltecs and the Aztecs",255,"Montreal is the second largest city in Canada. A famous landmark is Notre Dame de Bonsecours",255,"There are three Comoro Islands, one with an active volcano",255,"Welcome to Moscow. The massive Kremlin compound, once the home of the Tsars, is located in Moscow",255,"Welcome to New Delhi, the capital of India, and site of the ancient Red Fort, the former Mogul palace",255,"The headquarters of the United Nations, located in New York, adds to the multi-cultural feel of the city",255,"Welcome to Oslo, the capital of Norway, a country known for its beautiful fjords",255,"Welcome to Paris, the capital of France, and home of the world-famous Eiffel Tower",255,"Peking, with a population of about 8.5 million, is the second largest city in the People's Republic of China",255,"Welcome to Port Moresby, the capital of Papua New Guinea, a country of jungles and volcanic mountains",255,"Iceland has vast areas of glaciers and lava desert, as well as many hot-water springs and geysers",255,"The capital of Brazil is Brasilia, a new city built in the interior of the country",255,"During the Renaissance, Italy was a vital center of art, science and learning",255,"San Marino, located on the slopes of Mount Titano, is completely surrounded by Italy",255,"Singapore has a population of about 2.5 million people, and is the site of one of the world's largest ports",255,"The capital of Australia is Canberra, located in the southeast of the country between Sydney and Melbourne",255,"Japan consists of four main islands, Honshu, where Tokyo is located, Hokkaido, Kyushu, and Shikoku",255
City_descriptions: db 255,"Welcome to Athens",255,"Iraq's neighbors are",255,"Bamako is the capital of Mali.",255
Fin_city_descriptions: