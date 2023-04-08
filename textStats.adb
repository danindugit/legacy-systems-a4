--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Text_IO; use Ada.Text_IO; -- for I/O operations
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

package body textStats is

   procedure getFilename(filename : out unbounded_string) is
   begin
      loop
         -- Prompt the user for a file name
         put("Please enter the name of the file: ");
         get_line(filename);

         -- Check if the file exists
         if CheckFileExists(filename) then
            -- If the file exists, return the file name
            return;
         else
            -- If the file does not exist, prompt the user again
            put_line("The file does not exist. Please enter a valid file name.");
         end if;
      end loop;
   end getFilename;

   procedure analyzeText(filename : in unbounded_string) is
      currWord : unbounded_string := "";
      fptr : file_type;
      ch : character;
      charsInWord : int := 0;
      totalChars : int := 0;
      totalPunc : int := 0;
      totalWords : int := 0;
      totalNumbers : int := 0;
   begin
      -- Open the file for reading
      open(fptr, in_file, filename);

      -- Loop through each character of the file
      while not end_of_file(fptr) loop
         -- Loop through characters until the character is not one of the following: ('!', '.', '?', ' ')
         loop
            get(fptr, ch);
            if(isPunct(ch)) then
               totalPunc := totalPunc + 1;
            end if;
            exit when ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ';
            put(ch);
         end loop;

         --  if the current character is not punctuation (a word begins)
         if ch /= '!' and ch /= '.' and ch /= '?' then
            charsInWord := charsInWord + 1;
         elsif isNum(ch) then
            totalNumbers := totalNumbers + 1;
            --  loop until the end of the number
            loop
               get(fptr, ch);
               exit when not isNum(ch);
            end loop;
         end if;

         -- Loop until end of line or until the character is not one of the following: ('!', '.', '?', ' ')
         loop
            exit when end_of_line(fptr);
            get(fptr, ch);
            exit when ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ';
            put(ch);
            if isLetter(ch) then
               totalWords := totalWords + 1;
               charsInWord := charsInWord + 1;
               --  append characters to currWord
               currWord := currWord & To_Unbounded_String(ch);

               --  loop until the end of the word
               loop
                  get(fptr, ch);
                  exit when not isLetter(ch);
                  --  append characters to currWord
                  currWord := currWord & To_Unbounded_String(ch);
               end loop;
               
               exit; -- after looping through a word, exit the loop
            elsif isNum(ch) then
               totalNumbers := totalNumbers + 1;
               --  loop until the end of the number
               loop
                  get(fptr, ch);
                  exit when not isNum(ch);
               end loop;
               exit; -- after looping through a number, exit the loop
            end if;
         end loop;
         
      end loop;

      -- close the file
      close(fptr);

   end analyzeText;

   function CheckFileExists(filename : in Unbounded_String) return boolean is
      filename_Str : constant String := to_string(filename);
   begin
      return Exists(filename_Str);
   end CheckFileExists;

   function isPunc(ch : character) return boolean is
   begin
      case ch is
         when '.' | ',' | ';' | ':' | '?' | '!' | '-' | '\'' | '"' | '(' | ')' | '[' | ']' | '{' | '}' =>
            return true;
         -- add any additional punctuation marks here
         when others =>
            return false;
      end case;
   end isPunc;

   function isNum(ch : character) return boolean is
   begin
      return character'val(character'pos(ch) in 48..57);
   end isNum;

   function isLetter(ch : character) return boolean is
   begin
      return character'val(character'pos(ch) in 65..90 or 97..122);
   end isLetter;

end textStats;
