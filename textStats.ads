--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package textStats is
   type string_array is array (positive range <>) of unbounded_string;
   procedure getFilename(filename : out unbounded_string);
   procedure analyzeText(filename : in unbounded_string);
   function CheckFileExists(filename : in Unbounded_String) return boolean;
   function isPunc(ch : character) return boolean;
   function isNum(ch : character) return boolean;
   function isLetter(ch : character) return boolean;
   function count_spaces_in_file(filename : string) return integer;
   procedure append_to_string_array(word : string; strings : in out string_array);
   procedure end_of_sent_check(ch : in character; totalSents : in out integer; totalWords : in out integer; longestSent : in out integer; wordsInSent : in out integer);
end textStats;