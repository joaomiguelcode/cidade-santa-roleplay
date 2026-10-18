-- new_spawn sql prepares
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

vRP.prepare('characters/Characters', 'SELECT * FROM characters WHERE license = @license AND deleted = 0')
vRP.prepare('characters/countPersons', 'SELECT COUNT(*) as qtd FROM characters WHERE license = @license AND deleted = 0')
vRP.prepare('characters/newPerson', 'INSERT INTO characters (license, name, name2, sex, age) VALUES (@license, @name, @name2, @sex, @age)')
