nombre_fichero_entrada = "prueba.scr"
nombre_fichero_salida = "prueba_sorted.scr"
with open(nombre_fichero_entrada, "rb") as fichero_entrada, open(nombre_fichero_salida,"wb") as fichero_salida:
    lista_tercios = []
    for tercio in range(3):
        lista_filas = []
        for fila in range(8):
            lista_scanlines = []
            for scanline in range(8):
                array_fila = bytearray(32)
                for columna in range(32):
                    mi_byte = fichero_entrada.read(1)
                    print(mi_byte)
                    array_fila[columna]=int.from_bytes(mi_byte,"little")
                lista_scanlines.append(array_fila)
            lista_filas.append(lista_scanlines)
        lista_tercios.append(lista_filas)
    atributos = bytearray(768)
    for i in range(768):
        byte_atributo = fichero_entrada.read(1)
        atributos[i] = int.from_bytes(byte_atributo,"little")

    print("Fichero leído: "+nombre_fichero_entrada)
    print("Escribiendo en: "+nombre_fichero_salida)

        
    for tercio in range(3):
        lista_filas = lista_tercios[tercio]
        for fila in range(8):
            lista_scanlines = lista_filas[fila]
            for scanline in range(8):
                array_fila = lista_scanlines[scanline]
                for columna in range(32):
                    mi_byte_salida = array_fila[columna]
                    fichero_salida.write(int.to_bytes(mi_byte_salida,1,"little"))
                
    for i in range(768):
        byte_atributo = atributos[i]
        fichero_salida.write(int.to_bytes(byte_atributo,1,"little"))
        
    
    
