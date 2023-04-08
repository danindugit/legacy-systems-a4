--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package textStats is
   procedure getFilename(filename : out unbounded_string);
   function CheckFileExists(filename : in Unbounded_String) return boolean;
end textStats;