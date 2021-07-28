
Groups = {}
Permissions = {}
Lang = {}
Lang.Global = {}
Config = {}

-- Config --

Config.AmbulanceJob = true

Config.WarnPerma = 10
Config.WarnWeek = 6
Config.WarnDays = 3

Config.Jails = {
    {x = 1641.64, y = 2571.08, z = 45.56},
    {x = 1651.03, y = 2570.78, z = 45.56}
}
Config.ExitFromJail = {["x"] = 1873.51, ["y"] = 2600.2, ["z"] = 45.67}
Config.MaxJailDistance = 20
Config.JailWarns = 2
Config.JailWarnsMinutes = 20

Config.CheckJobType = "false" -- esx/sql/false
Config.DefaultJob = {"unemployed", 0}

Config.SecurityCode = "674521"

-- Config --


Groups.Server       = "server" 
Groups.SuperAdmin   = "admin" 
Groups.Admin        = "admin"
Groups.Mod          = "mod"
Groups.Helper       = "helper"
Groups.User         = "user" 


Groups.Levels = {[Groups.User] = 0, [Groups.Helper] = 1, [Groups.Mod] = 2, [Groups.Admin] = 3, [Groups.SuperAdmin] = 4, [Groups.Server] = 5}

-- Establecer los permisos de menos nivel a mas nivel --

-- Permisos --

Permissions.OpenMenu        = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.GetWarns        = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Warn            = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.DeleteWarn      = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Kick            = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Ban             = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.GetBans         = {Groups.SuperAdmin, Groups.Server}
Permissions.Bring           = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Goto            = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Return          = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Noclip          = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Visibility      = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Slay            = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Revive          = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Freeze          = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Jail            = {Groups.Mod, Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.UnJail          = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Money           = {Groups.SuperAdmin, Groups.Server,Groups.Admin}
Permissions.Jobs            = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Group           = {Groups.Admin, Groups.SuperAdmin, Groups.Server}
Permissions.Report          = {Groups.Mod, Groups.Admin, Groups.SuperAdmin}

-- Permisos --

-- Lenguaje --

Lang.Error                      = "Error"
Lang.Success                    = "Aparcao"
Lang.Minutes                    = "minutos"
Lang.Plus                       = "mas"

Lang.Kicked                     = "Se ha kickeado correctamente a "
Lang.BannedSuccessfully         = "El usuario fue baneado correctamente"
Lang.Warn                       = "Warn aplicado correctamente a "
Lang.WarnDeleted                = "Warn eliminado correctamente por "
Lang.UnBan                      = "Se ha eliminado la restricción"
Lang.ReturnPlayer               = " te ha devuelto a tu ubicación anterior"
Lang.NoclipOn                   = "Se ha ^2activado^0 el noclip"
Lang.NoclipOff                  = "Se ha ^1desactivado^0 el noclip"
Lang.Noclip                     = "Se le ha ortorgado/desotorgado noclip a: "
Lang.Slay                       = "Has muerto misteriosamente ;)"
Lang.Revive                     = "Has resurgido de entre los muertos"
Lang.FreezeMsg                  = "Has sido ^1congelado^0"
Lang.UnFreezeMsg                = "Has sido ^2descongelado^0"
Lang.Warned                     = " ^1te ha aplicado un warn por: "
Lang.WarnAccumulation           = "Acumulacion de warns. Warns: "
Lang.BannedFor                  = "Baneado por: %s | Fecha de expiración: %s | Aplicado por: %s"
Lang.PermaBan                   = "Baneado por: %s | Fecha de expiración: Nunca | Aplicado por: %s"
Lang.Banned                     = "Baneado"
Lang.Bringed                    = "Has sido teletransportado hacia "
Lang.Goto                       = " se ha teletransportado hacia ti"
Lang.GotoN                      = "Has sido teletransportado hacia "
Lang.Return                     = "El jugador ha sido devuelto a su ubicación anterior"
Lang.Visibility                 = "El jugador es visible/invisible para los jugadores"
Lang.Slay                       = "El jugador murio en extrañas circustancias"
Lang.ReviveN                    = "Se ha curado y revivido al jugador"
Lang.Freeze                     = "El jugador ha sido congelado/descongelado correctamente"
Lang.JailError                  = "El jugador no ha sido encerrado a causa de un error interno"
Lang.UnJail                     = "Se ha liberado al jugador de su condena"
Lang.UnjailError                = "No se ha liberado al jugador a causa de un error interno"
Lang.Jailed                     = "Has sido encerrado por "
Lang.UnJailed                   = "Has cumplido tu condena^0. No la ^1lies^0 mas"
Lang.Jail                       = "El jugador ha sido encerrado"
Lang.JailMaxWarns               = "Se ha aumentado tu condena " .. tostring(Config.JailWarnsMinutes) .. " " .. Lang.Minutes .. " por incumplimiento de la misma"
Lang.JailMaxDistance            = "No intentes escapar o se te aumentara la condena"
Lang.WarnError                  = "No se pudo aplicar el warn a causa de un error interno"
Lang.WarnDeletedError           = "No se pudo eliminar el warn a causa de un error interno"
Lang.BanError                   = "No se pudo aplicar el baneo a causa de un error interno"
Lang.UnBanError                 = "No se pudo eliminar el baneo a causa de un error interno"
Lang.ReturnError                = "No se pudo devolver a la ubicación anterior ya que no existe"
Lang.Cash                       = "Se ha añadido dinero al jugador de tipo: "
Lang.ESX                        = "Ha ocurrido un error en la conexión con ESX"
Lang.JobFail                    = "El trabajo no existe"
Lang.Job                        = "Trabajo cambiado a "
Lang.Money                      = "Se le ha dado al jugador dinero de tipo: "
Lang.JobFailKick                = "Se le ha expulsado del servidor ya que su trabajo era invalido"
Lang.GroupUpgraded              = "Se le ha establecido el grupo: ^1"
Lang.Group                      = "Se le ha establecido el grupo: "
Lang.GroupError                 = "Ha ocurrido un error inseperado y no se ha podido cambiar el grupo"
Lang.FixJob                     = "Se le ha establecido el trabajo por defecto a "
Lang.JailedTime                 = "Te quedan %s segundos para cumplir tu condena"
Lang.ArgumentNeeded             = "Faltan argumentos"
Lang.MySQL                      = "La base de datos no esta conectada todavía."
Lang.Report                     = "^0[^1Report^0] ^3%s^0 (^2%s^0) | %s"

Lang.InsufficientPrivileges     = "No tienes privilegios suficientes"
Lang.SecurityGodMode            = "Se ha detectado que usted usa ilegitimamente la funcion nativa SetPlayerInvincible"
Lang.SecurityWeapons            = "Se ha detectado que usted tiene un arma no permitida por el servidor"


Lang.Global.PlayerJailed        = "^1%s^0 ha ingresado en la carcel por %s minutos."
Lang.Global.PlayerBanned        = "^1%s^0 ha sido baneado del servidor por: ^1%s^0."

-- Lenguaje --