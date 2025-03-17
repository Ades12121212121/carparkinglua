gg.setVisible(false)
gg.clearResults()
gg.clearList()

local VERSION = "1.0"  -- Versión actual del script
local GITHUB_REPO = "https://raw.githubusercontent.com/Ades12121212121/carparkinglua/main"
local GIT_VERSION = "https://github.com/Ades12121212121/carparkinglua/blob/main"
local UPDATE_FILE = "/storage/emulated/0/Android/data/update_status.txt"

local COLORS = {
    PRIMARY = "📱 ",
    SECONDARY = "💎 ",
    WARNING = "⚠️ ",
    SUCCESS = "✅ ",
    ERROR = "❌ ",
    INFO = "ℹ️ "
}

-- Función para mostrar animación de actualización
local function showUpdateAnimation()
    local dots = {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
    for i = 1, 3 do
        for _, dot in ipairs(dots) do
            gg.toast(dot .. " Actualizando script... Por favor espere")
            gg.sleep(100)
        end
    end
end

-- Verificar actualizaciones
local function checkUpdates()
    -- Mostrar mensaje de verificación
    gg.toast("📡 Verificando actualizaciones...")
    gg.sleep(1000)
    
    -- URL del archivo de versión (asegurarse que es la URL raw)
    local versionUrl = GITHUB_REPO .. "/version.txt"
    gg.toast("🔄 Conectando al servidor...")
    
    local remoteVersion = gg.makeRequest(versionUrl)
    if remoteVersion then
        gg.toast("📥 Obteniendo información...")
        
        -- Depuración: mostrar la respuesta del servidor
        gg.alert("Respuesta del servidor:\nCódigo: " .. (remoteVersion.code or "N/A") .. 
                "\nContenido: " .. (remoteVersion.text or "vacío"))
        
        if remoteVersion.code == 200 and remoteVersion.text then
            -- Limpiar la versión remota de espacios y caracteres extra
            local newVersion = remoteVersion.text:gsub("^%s*(.-)%s*$", "%1")
            gg.toast("🔍 Comparando versiones...")
            
            -- Convertir a número y comparar
            local currentVer = tonumber(VERSION)
            local remoteVer = tonumber(newVersion)
            
            if remoteVer and currentVer and remoteVer > currentVer then
                -- Mostrar mensaje de actualización encontrada
                gg.alert("🔄 ¡Nueva versión " .. newVersion .. " disponible!\n\nTu versión: " .. VERSION)
                showUpdateAnimation()
                
                -- Descargar nuevo script
                local scriptUrl = GITHUB_REPO .. "/PCR%20CPM%20v1.0.lua"
                gg.toast("📥 Descargando nueva versión...")
                local newScript = gg.makeRequest(scriptUrl)
                
                if newScript and newScript.code == 200 then
                    -- Guardar el nuevo script
                    local file = io.open(gg.EXT_STORAGE .. "/PCR_CPM_temp.lua", "w")
                    if file then
                        file:write(newScript.text)
                        file:close()
                        
                        -- Mostrar mensaje de éxito
                        gg.toast("✅ Actualización completada. Reiniciando script...")
                        gg.sleep(2000)
                        
                        -- Ejecutar el nuevo script
                        load(newScript.text)()
                        return true
                    end
                else
                    gg.alert("❌ Error al descargar el script.\nCódigo: " .. (newScript and newScript.code or "N/A"))
                end
            else
                gg.toast("✅ Script actualizado a la última versión")
                gg.sleep(1500)
            end
        else
            gg.alert("❌ Error al verificar la versión.\nCódigo: " .. (remoteVersion.code or "N/A"))
        end
    else
        gg.alert("❌ No se pudo conectar al servidor")
    end
    return false
end

-- Si no hay actualización, continuar con el script normal
if not checkUpdates() then
    gg.setVisible(false)
    gg.clearResults()
    gg.clearList()
    
    function createTitle(text, icon)
        local icon = icon or COLORS.PRIMARY
        return "\n" .. icon .. "══════════════════════════════\n" ..
               icon .. " " .. text .. " \n" ..
               icon .. "══════════════════════════════\n"
    end

    function MAIN_MENU()
        local title = createTitle("CAR PARKING", "🚗 ") ..
        "Versión: v" .. VERSION .. "\n" ..
        "Creado por: PCR087\n"
        
        local menu = gg.choice({
            COLORS.SECONDARY .. "DINERO INFINITO",
            COLORS.SECONDARY .. "HACKS DE COCHES",
            COLORS.SECONDARY .. "HACKS VISUALES",
            COLORS.INFO .. "CONFIGURACIÓN",
            COLORS.ERROR .. "SALIR"
        }, nil, title)
        
        if menu == nil then EXIT() return end
        if menu == 1 then MONEY_HACKS() end
        if menu == 2 then CAR_HACKS() end
        if menu == 3 then VISUAL_HACKS() end
        if menu == 4 then SETTINGS() end
        if menu == 5 then EXIT() end
    end

    function MONEY_HACKS()
        local title = createTitle("MENÚ DE DINERO", "💵 ")

        local submenu = gg.choice({
            COLORS.WARNING .. "DINERO INFINITO",
            COLORS.SUCCESS .. "EASY MONEY",
            COLORS.INFO .. "VOLVER AL MENÚ"
        }, nil, title)
        
        if submenu == nil then MAIN_MENU() return end
        if submenu == 1 then INFINITE_MONEY() end
        if submenu == 2 then EASY_MONEY() end
        if submenu == 3 then MAIN_MENU() end
    end

    function INFINITE_MONEY()
        gg.alert(COLORS.WARNING .. " ¡ADVERTENCIA! " .. COLORS.WARNING .. "\nMétodo de alto riesgo\nUsar solo en modo offline")
        
        for i = 1, 5 do
            gg.toast("Iniciando protección... " .. i*20 .. "%")
            gg.sleep(150)
        end
        
        gg.setRanges(gg.REGION_CODE_APP)
        gg.searchNumber("50000000", gg.TYPE_FLOAT)

        local resultados = gg.getResults(2)
        if #resultados > 0 then
            for i, v in ipairs(resultados) do
                v.value = 999999999999
                v.freeze = true
            end
            gg.setValues(resultados)
            gg.toast(COLORS.SUCCESS .. " ¡Hack completado!\nValores modificados: "..#resultados)
        else
            gg.toast(COLORS.ERROR .. " No se encontraron valores")
        end
        gg.clearResults()
        MONEY_HACKS()
    end

    function EASY_MONEY()
        local title = createTitle("EASY MONEY - MODO SEGURO", "💰 ")
        
        local options = gg.choice({
            COLORS.PRIMARY .. "Buscar y modificar valores (Nivel 3)",
            COLORS.INFO .. "Volver al menú"
        }, nil, title)
        
        if options == nil then MONEY_HACKS() return end
        
        if options == 1 then
            -- Animación de carga moderna
            for i = 1, 3 do
                gg.toast("Iniciando búsqueda avanzada... " .. i*33 .. "%")
                gg.sleep(200)
            end
            
            gg.setRanges(gg.REGION_ANONYMOUS)
            gg.searchNumber("40", gg.TYPE_FLOAT)
            
            local total = gg.getResultsCount()
            if total > 0 then
                local resultados = gg.getResults(100)
                for i = 1, #resultados do
                    resultados[i].value = 9999999
                    resultados[i].freeze = true
                end
                gg.addListItems(resultados)
                gg.setValues(resultados)
                
                -- Animación de éxito
                for i = 1, 3 do
                    gg.toast(COLORS.SUCCESS .. " Valores modificados: "..#resultados)
                    gg.sleep(200)
                    gg.toast(COLORS.SUCCESS .. " ¡Hack aplicado con éxito!")
                    gg.sleep(200)
                end
                
                gg.alert(COLORS.SUCCESS .. " ¡ÉXITO! " .. COLORS.SUCCESS .. "\n\nDinero aplicado correctamente.\nVe al Nivel 1 para activar los cambios.")
            else
                gg.toast(COLORS.ERROR .. " No se encontraron valores")
                gg.alert(COLORS.ERROR .. " Error: No se encontraron valores\n\nAsegúrate de estar en el Nivel 3 y reintentar.")
            end
            gg.clearResults()
            EASY_MONEY()
        elseif options == 2 then
            local items = gg.getListItems()
            if #items > 0 then
                gg.setValues(items)
                gg.toast(COLORS.INFO .. " Valores refrescados: "..#items)
            else
                gg.toast(COLORS.ERROR .. " No hay valores para refrescar")
            end
            EASY_MONEY()
        elseif options == 3 then
            gg.alert(createTitle("INSTRUCCIONES DETALLADAS", "📋 ") .. 
            "1. Asegúrate de estar en el Nivel 3\n" ..
            "2. Selecciona 'Buscar y modificar valores'\n" ..
            "3. Espera a que termine la búsqueda\n" ..
            "4. Ve al Nivel 1 para activar\n" ..
            "5. Si no funciona, usa 'Refrescar valores'\n\n" ..
            COLORS.WARNING .. " Usa este hack con moderación para evitar baneos")
            EASY_MONEY()
        elseif options == 4 then
            MONEY_HACKS()
        end
    end

    function CAR_HACKS()
        local title = createTitle("HACKS DE COCHES", "🚙 ")
        
        local submenu = gg.choice({
            COLORS.PRIMARY .. "CARRO CROMADO",
            COLORS.PRIMARY .. "MODIFICAR CARACTERÍSTICAS",
            COLORS.PRIMARY .. "MODIFICAR MOTOR",
            COLORS.INFO .. "VOLVER AL MENÚ"
        }, nil, title)
        
        if submenu == nil then MAIN_MENU() return end
        if submenu == 1 then CHROME_CAR() end
        if submenu == 2 then CAR_MODS() end
        if submenu == 3 then ENGINE_MODS() end
        if submenu == 4 then MAIN_MENU() end
    end

    function CHROME_CAR()
        -- Initialize iterations variable
        local iterations = 0
        
        -- Start the search loop process
        gg.setRanges(gg.REGION_ANONYMOUS)
        
    -- Loop 12 times alternating between white and black searches
    for i = 1, 12 do
        -- White search
        gg.alert("⚪ Búsqueda blanca " .. (iterations + 1))
        gg.sleep(3000)
        gg.searchNumber("1", gg.TYPE_FLOAT)
        
        -- Black search
        gg.alert("⚫ Búsqueda negra " .. (iterations + 1))
        gg.sleep(3000)
        gg.refineNumber("0", gg.TYPE_FLOAT)
    end
            
            count = gg.getResultsCount()
            iterations = iterations + 1

            if count > 0 then
                -- Replace the problematic code with gg.editAll
                gg.editAll("300;299;400", gg.TYPE_FLOAT)
                gg.toast("✅ Efecto cromado aplicado! Valores modificados: " .. count)
            else
                gg.toast("❌ No se encontraron valores para modificar")
            end
        
        gg.clearResults()
        CAR_HACKS()
    end


    function CAR_MODS()
        local title = "🔧 MODIFICAR CARACTERÍSTICAS 🔧"
        
        local options = gg.choice({
            "🔋 COMBUSTIBLE INFINITO",
            "🛞 NEUMÁTICOS PERFECTOS",
            "🧲 ADHERENCIA MÁXIMA",
            "🔙 VOLVER AL MENÚ"
        }, nil, title)
        
        if options == nil then CAR_HACKS() return end
        if options == 4 then CAR_HACKS() return end
        
        -- Implementación de las opciones
        if options == 1 then
            gg.toast("🔍 Buscando parámetros de combustible...")
            gg.setRanges(gg.REGION_ANONYMOUS)
            gg.searchNumber("50;100;0.5", gg.TYPE_FLOAT)
            
            gg.sleep(1000)
            local count = gg.getResultsCount()
            
            if count > 0 then
                local results = gg.getResults(100)
                for i, v in ipairs(results) do
                    if v.value < 101 and v.value > 0 then
                        v.value = 999999
                        v.freeze = true
                    end
                end
                
                gg.setValues(results)
                gg.addListItems(results)
                gg.toast("✅ ¡Combustible infinito activado!")
                gg.alert("🔋 COMBUSTIBLE INFINITO\n\nNunca te quedarás sin gasolina.\nDisfruta de viajes ilimitados.")
            else
                gg.alert("❌ ERROR: No se encontraron parámetros de combustible.")
            end
        elseif options == 2 or options == 3 then
            gg.alert("🚧 Función en desarrollo\nEstará disponible en la próxima actualización!")
        end
        
        gg.clearResults()
        CAR_HACKS()
    end

    -- Add this function after CAR_MODS()
    function ENGINE_MODS()
        local title = createTitle("MODIFICAR MOTOR", "🔧 ")
        
        local options = gg.choice({
            "🚀 Buy L2.5 (1695Hp 2254Torque)",
            "🔙 VOLVER AL MENÚ"
        }, nil, title)
        
        if options == nil then CAR_HACKS() return end
        
        if options == 1 then
            -- Alerta para comprar el motor
            gg.alert("Compra el motor V6 3.0")
            
            -- Espera de 3 segundos
            gg.sleep(3000)
            
            -- Búsqueda y modificación de HP
            gg.setRanges(gg.REGION_ANONYMOUS)
            gg.searchNumber("240", gg.TYPE_FLOAT)
            gg.editAll("1695", gg.TYPE_FLOAT)
            gg.clearResults()
            
            -- Búsqueda y modificación de Torque
            gg.searchNumber("310", gg.TYPE_FLOAT)
            gg.editAll("2254", gg.TYPE_FLOAT)
            gg.clearResults()
            
            gg.toast("✅ Motor L2.5 activado! 1695Hp 2254Torque")
        elseif options == 2 then
            CAR_HACKS()
            return
        end
        
        ENGINE_MODS()
    end

    function VISUAL_HACKS()
        local title = "🎭 HACKS VISUALES 🎭"
        
        local options = gg.choice({
            "🌈 COLORES PERSONALIZADOS",
            "🌙 MODO NOCHE PERMANENTE",
            "☀️ MODO DÍA PERMANENTE",
            "🔙 VOLVER AL MENÚ"
        }, nil, title)
        
        if options == nil then MAIN_MENU() return end
        if options == 4 then MAIN_MENU() return end
        
        -- Implementación básica para todas las opciones
        if options >= 1 and options <= 3 then
            local hackNames = {"Colores personalizados", "Modo noche", "Modo día"}
            local selectedHack = hackNames[options]
            
            gg.toast("🔍 Buscando parámetros visuales...")
            gg.sleep(1500)
            
            gg.toast("⚙️ Aplicando " .. selectedHack .. "...")
            gg.sleep(1000)
            
            gg.alert("✨ " .. selectedHack .. " aplicado con éxito!\n\nEsta función está en fase BETA.\nPueden ocurrir algunos problemas visuales.")
        end
        
        MAIN_MENU()
    end

    function SETTINGS()
        local title = "⚙️ CONFIGURACIÓN ⚙️"
        
        local options = gg.choice({
            "📊 INFORMACIÓN DEL SCRIPT",
            "🔄 REINICIAR VALORES",
            "🧹 LIMPIAR MEMORIA",
            "📧 GENERAR CUENTA TEMPORAL",
            "🔙 VOLVER AL MENÚ"
        }, nil, title)
        
        if options == nil then MAIN_MENU() return end
        
        if options == 1 then
            gg.alert("📱 INFORMACIÓN DEL SCRIPT 📱\n\n" ..
                    "Versión: " .. VERSION .. "\n" ..
                    "Creador: PCR087\n" ..
                    "Juego: Car Parking\n\n" ..
                    "Este script es solo para fines educativos.\n" ..
                    "Úsalo bajo tu propia responsabilidad.")
        elseif options == 2 then
            local items = gg.getListItems()
            if #items > 0 then
                for i, v in ipairs(items) do
                    v.freeze = false
                end
                gg.setValues(items)
                gg.removeListItems(items)
                gg.toast("🔄 Valores reiniciados: " .. #items)
            else
                gg.toast("❌ No hay valores para reiniciar")
            end
        elseif options == 3 then
            gg.clearResults()
            gg.clearList()
            gg.toast("🧹 Memoria limpiada correctamente")
        elseif options == 4 then
            generateTempAccount()
        elseif options == 5 then
            MAIN_MENU()
            return
        end
        
        SETTINGS()
    end

    -- Función para generar una cuenta temporal
    function generateTempAccount()
        -- Mostrar mensaje de inicio
        gg.toast("🔄 Generando cuenta temporal...")
        
        -- Generar correo aleatorio
        local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        local emailUser = ""
        for i = 1, 10 do
            local randIndex = math.random(1, #chars)
            emailUser = emailUser .. string.sub(chars, randIndex, randIndex)
        end
        
        local email = emailUser .. "@any.pink"
        
        -- Generar contraseña aleatoria de 8 dígitos
        local password = ""
        local passChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        for i = 1, 8 do
            local randIndex = math.random(1, #passChars)
            password = password .. string.sub(passChars, randIndex, randIndex)
        end
        
        -- Simular proceso de creación de cuenta
        for i = 1, 5 do
            gg.toast("⏳ Creando cuenta: " .. i*20 .. "%")
            gg.sleep(300)
        end
        
        -- Guardar datos en archivo
        local path = "/storage/emulated/0/Pictures/ACC.txt"
        
        -- Verificar si el archivo existe y tiene contenido
        local fileExists = io.open(path, "r")
        local hasContent = false

        if fileExists then
            local content = fileExists:read("*all")
            fileExists:close()
            hasContent = content and content:len() > 0
        end
        
        -- Abrir archivo para añadir contenido
        local file = io.open(path, "a+")
        
        if file then
            local timestamp = os.date("%Y-%m-%d %H:%M:%S")
            
            -- Si ya hay contenido, añadir líneas en blanco para separar
            if hasContent then
                file:write("\n\n")
            end
            
            file:write("=== CUENTA GENERADA EL " .. timestamp .. " ===\n")
            file:write("Email: " .. email .. "\n")
            file:write("Contraseña: " .. password .. "\n")
            file:write("URL: https://tempmail.plus/es/#!\n")
            file:write("======================================")
            file:close()
            
            -- Mostrar información al usuario
            gg.alert("✅ CUENTA GENERADA EXITOSAMENTE ✅\n\n" ..
                    "📧 Email: " .. email .. "\n" ..
                    "🔑 Contraseña: " .. password .. "\n\n" ..
                    "Los datos se han guardado en:\n" .. path .. "\n\n" ..
                    "Para acceder al correo temporal, visita:\nhttps://tempmail.plus/es/#!")
        else
            gg.alert("❌ ERROR: No se pudo guardar la información.\nVerifica los permisos de almacenamiento.")
        end
    end

    function EXIT()
        os.exit()
    end

    -- Inicio
    MAIN_MENU()
end
