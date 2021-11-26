Cities: db 255,13,"    HQ",255,"  Athens",255," Baghdad",255,"  Bamako",255," Bangkok",255," Budapest",255,"  Buenos",13,"  Aires",255,"  Cairo",255," Colombo",255," Istanbul",255,"Kathmandu",255,"  Kigali",255,"   Lima",255,"  London",255,"  Mexico",13,"  City",255," Montreal",255,"  Moroni",255,"  Moscow",255,"New Delhi",255," New York",255,"   Oslo",255,"  Paris",255,"  Peking",255,"   Port",13," Moresby",255,"Reykjavik",255,"  Rio de",13," Janeiro",255,"   Rome",255,"San Marino",255,"Singapore",255," Sydney",255,"  Tokyo",255
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
Cursor: db 1
Sound: db 0
Cursor_botones: db Button_depart_x_inicial, Button_lupa_x_inicial, Button_crime_x_inicial
;Screen_source_address_offset db 0 ; 0/10/20
Aux_screen_horizontal_offset: db 0 ; 0/10/20
Aux_screen_vertical_offset: db 0 ; 0/128
CurrentCity: db 0 ; rango [1,30]
CurrenCityConfigOffsetX: db 0,10,20,0,10,20
CurrenCityConfigOffsetY: db 0,0,0,128,128,128
CurrentCountry: db 28
CurrentWeekday: db 3 ; EMPIEZA EN 1
CurrentHour: db "0900",255
Mensajes_impresora: db "En un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que vivia un hidalgo de los de lanza en astillero, adarga antigua, rocin flaco y galgo corredor",255
City_descriptions: db 255,"    ",255,"Welcome to Athens,the capital of",13,"Greece, and home",13,"of the famous",13,"Parthenon",255,"Iraq's neighbors",13,"are Jordan, Syria,Turkey, Iran,",13,"Kuwait and Saudi",13,"Arabia",255,"Bamako is the",13,"capital of Mali.",13,"This country is",13,"also the site of",13,"the ancient desertoutpost of",13,"Timbuktu",255,"Welcome to",13,"Bangkok, the",13,"capital of",13,"Thailand. Bangkok is laced with",13,"canals and dotted with pagodas",255,"Budapest, with a",13,"population of 2",13,"million, was once two cities, Buda",13,"and Pest,",13,"separated by the",13,"Danube River",255,"The fertile",13,"Pampas, or plains,region in central",13,"Argentina providesan abundance of",13,"beef and grain",255,"Cairo, with a",13,"population of morethan 5 million, isthe largest city",13,"in Africa",255,"Welcome to",13,"Colombo, the",13,"capital of Sri",13,"Lanka, a",13,"mountainous",13,"island nation off the southeast",13,"coast of India",255,"Turkey, which has hot dry summers",13,"and cold winters, is ringed by",13,"mountains on all",13,"but the western",13,"border",255,"Welcome to",13,"Kathmandu, the",13,"capital of Nepal, located high in",13,"the Himalayas",255,"Rwanda is a",13,"country of lush",13,"jungle terrain,",13,"and the home of",13,"rare mountain",13,"gorillas",255,"Welcome to Lima,",13,"the capital of",13,"Peru. This Andean nation was once",13,"the center of the Incan empire",255,"London is the",13,"capital of the",13,"United Kingdom,",13,"which consists of England, Scotland,Wales and NorthernIreland",255,"Mexico was the",13,"site of the",13,"advanced Indian",13,"civilizations of",13,"the Mayans, the",13,"Toltecs and the",13,"Aztecs",255,"Montreal is the",13,"second largest",13,"city in Canada. A famous landmark isNotre Dame de",13,"Bonsecours",255,"There are three",13,"Comoro Islands,",13,"one with an activevolcano",255,"Welcome to Moscow.The massive",13,"Kremlin compound, once the home of",13,"the Tsars, is",13,"located in Moscow",255,"Welcome to New",13,"Delhi, the capitalof India, and siteof the ancient RedFort, the former",13,"Mogul palace",255,"The headquarters",13,"of the United",13,"Nations, located",13,"in New York, adds to the",13,"multi-cultural",13,"feel of the city",255,"Welcome to Oslo,",13,"the capital of",13,"Norway, a country known for its",13,"beautiful fjords",255,"Welcome to Paris, the capital of",13,"France, and home",13,"of the",13,"world-famous",13,"Eiffel Tower",255,"Peking, with a",13,"population of",13,"about 8,5 million,is the second",13,"largest city in",13,"the People's",13,"Republic of China",255,"Welcome to Port",13,"Moresby, the",13,"capital of Papua",13,"New Guinea, a",13,"country of junglesand volcanic",13,"mountains",255,"Iceland has vast",13,"areas of glaciers and lava desert,",13,"as well as many",13,"hot-water springs and geysers",255,"The capital of",13,"Brazil is",13,"Brasilia, a new",13,"city built in the interior of the",13,"country",255,"During the",13,"Renaissance, Italywas a vital centerof art, science",13,"and learning",255,"San Marino,",13,"located on the",13,"slopes of Mount",13,"Titano, is",13,"completely",13,"surrounded by",13,"Italy",255,"Singapore has a",13,"population of",13,"about 2,5 million people, and is thesite of one of theworld's largest",13,"ports",255,"The capital of",13,"Australia is",13,"Canberra, located in the southeast",13,"of the country",13,"between Sydney andMelbourne",255,"Japan consists of four main islands,Honshu, where",13,"Tokyo is located, Hokkaido, Kyushu, and Shikoku",255
Current_rank: db 0 ; [0-4]
Current_rank_message: db " Welcome to",13,"headquarters,",13,"your current",13,"rank is:", 255
Press_key_to_start_message: db "Press a key to start", 255
Ranks: db 32,13,"Rookie",255,13,"Sleuth",255,13,"Private eye",255,13,"Investigator",255,13,"Ace detective",255
NewLine: db 13,13,255
;0 cases solved = rookie
;1-3 cases solved = sleuth
;4-6 cases solved = private eye
;7-9 cases solved = investigator
;10-13 cases solved = ace detective
;14 cases solved : you get your name in the hall of fame

Fin_city_descriptions: