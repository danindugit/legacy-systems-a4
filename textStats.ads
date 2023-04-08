--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package textStats is
   procedure getFilename(filename : out unbounded_string);
   procedure analyzeText(filename : in unbounded_string);
   function CheckFileExists(filename : in Unbounded_String) return boolean;
   function isPunc(ch : character) return boolean;
   function isNum(ch : character) return boolean;
   function isLetter(ch : character) return boolean;
   function count_spaces_in_file(filename : string) return integer;
end textStats;