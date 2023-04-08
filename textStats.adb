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

   procedure analyzeText(filename : in unbounded_string; totalSpaces : in integer) is
      currWord : unbounded_string := "";
      fptr : file_type;
      ch : character;
      charsInWord : integer := 0;
      totalChars : integer := 0;
      totalPunc : integer := 0;
      totalWords : integer := 0;
      wordsInSent : integer := 0;
      longestSent : integer := 0;
      totalSents : integer := 0;
      totalNumbers : integer := 0;
      words : string_array(1..totalSpaces);
      longestWord : integer := 0;
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
         end loop;

         --  if the current character is not punctuation (a word begins)
         if ch /= '!' and ch /= '.' and ch /= '?' then
            if (isLetter) then
            charsInWord := charsInWord + 1;
            wordsInSent := wordsInSent + 1;
            --  append characters to currWord
            currWord := currWord & To_Unbounded_String(ch);

            --  loop until the end of the word
            loop
               get(fptr, ch);
               exit when not isLetter(ch);
               charsInWord = charsInWord + 1;
               --  append characters to currWord
               currWord := currWord & To_Unbounded_String(ch);
            end loop;

            --  check if this is the longest word
            if charsInWord > longestWord then
               longestWord := charsInWord;
            end if;

            --  add the chars in word to total chars
            totalChars := totalChars + charsInWord;
            --  reset charsInWord
            charsInWord := 0;
            --  add the word to the words array
            append_to_string_array(currWord, words);

            elsif isNum(ch) then
               totalNumbers := totalNumbers + 1;
               --  loop until the end of the number
               loop
                  get(fptr, ch);
                  exit when not isNum(ch);
               end loop;
            end if;
         end if;

         --  check for the end of a sentence
         end_of_sent_check(totalSents, totalWords, longestSent, wordsInSent);

         -- Loop until end of line or until the character is not one of the following: ('!', '.', '?', ' ')
         loop
            exit when end_of_line(fptr);
            get(fptr, ch);
            exit when ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ';

            if isLetter(ch) then
               charsInWord := charsInWord + 1;
               wordsInSent := wordsInSent + 1;
               --  append characters to currWord
               currWord := currWord & To_Unbounded_String(ch);

               --  loop until the end of the word
               loop
                  get(fptr, ch);
                  exit when not isLetter(ch);
                  charsInWord = charsInWord + 1;
                  --  append characters to currWord
                  currWord := currWord & To_Unbounded_String(ch);
               end loop;

               --  check if this is the longest word
               if charsInWord > longestWord then
                  longestWord := charsInWord;
               end if;

               --  add the chars in word to total chars
               totalChars := totalChars + charsInWord;
               --  reset charsInWord
               charsInWord := 0;
               --  add the word to the words array
               append_to_string_array(currWord, words);
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

         --  check for the end of a sentence
         end_of_sent_check(totalSents, totalWords, longestSent, wordsInSent);
         
      end loop;

      -- close the file
      close(fptr);

   end analyzeText;

   function CheckFileExists(filename : unbounded_string) return boolean is
      filename_Str : constant String := to_string(filename);
   begin
      return Exists(filename_Str);
   end CheckFileExists;

   function isPunc(ch : character) return boolean is
   begin
      case ch is
         when '.' | ',' | ';' | ':' | '?' | '!' | '-' | '\' | '"' | '(' | ')' | '[' | ']' | '{' | '}' =>
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

   function count_spaces_in_file(filename : string) return integer is
      fptr : file_type;
      ch : character;
      space_count : integer := 0;
   begin
      open(fptr, in_file, filename);

      while not end_of_file(fptr) loop
         get(fptr, ch);
         if ch = ' ' then
            space_count := space_count + 1;
         end if;
      end loop;

      close(fptr);

      return space_count;

   end count_spaces_in_file;

   procedure append_to_string_array(word : in string; strings : in out string_array) is
   begin
      strings(strings'length + 1) := to_unbounded_string(word);
   end append_to_string_array;

   procedure end_of_sent_check(ch : in character; totalSents : in out integer; totalWords : in out integer; longestSent : in out integer; wordsInSent : in out integer) is
   begin
      if ch = '!' or ch = '.' or ch = '?' or ch = ' ' then
         totalSents := totalSents + 1;
         totalWords := totalWords + wordsInSent;
         if longestSent < wordsInSent then
            longestSent = wordsInSent;
         end if;
         wordsInSent := 0;
      end if;
   end end_of_sent;

end textStats;
