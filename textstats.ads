--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package textstats is
   type string_array is array (positive range <>) of unbounded_string;
   procedure getFilename(filename : out unbounded_string);
   procedure analyzeText(filename : in unbounded_string; totalSpaces : in integer);
   function CheckFileExists(filename : in Unbounded_String) return boolean;
   function isPunc(ch : character) return boolean;
   function isNum(ch : character) return boolean;
   function isLetter(ch : character) return boolean;
   function count_spaces_in_file(filename : unbounded_string) return integer;
   function count_lines_in_file(filename : unbounded_string) return integer;
   procedure end_of_sent_check(ch : in character; totalSents : in out integer; totalWords : in out integer; longestSent : in out integer; wordsInSent : in out integer);
   procedure printHist(strings : string_array; totalWords: integer);
   function isWord(Word : String) return Boolean;
   function isNumber(num: String) return Boolean;
end textstats;