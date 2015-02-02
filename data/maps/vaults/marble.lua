-- Veins of the Earth
-- Zireael
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

setStatusAll{no_teleport=true, vault_only_door_open=true}

defineTile('.', "FLOOR")
defineTile('#', "WALL")
defineTile('%', "WALL_MARBLE")
defineTile('!', "DOOR")

return {
[[#!!#%!!#]],
[[#......#]],
[[%......%]],
[[#......#]],
[[%......%]],
[[#......#]],
[[#!!#%!!#]],
}