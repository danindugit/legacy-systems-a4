--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with Ada.Text_IO; use Ada.Text_IO; -- for I/O operations
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Characters.Handling;

package body textstats is

   --  procedure to prompt the user for the file name
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

   --  procedure to analyze the text in the file and output statistics
   procedure analyzeText(filename : in unbounded_string; totalSpaces : in integer) is
      currWord : unbounded_string := to_unbounded_string("");
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
      wordCount : integer := 0;
      tempStr : string(1..1);
      avgChars : float;
      avgWords : float;
   begin
      -- Open the file for reading
      open(fptr, in_file, to_string(filename));

      -- Loop through each character of the file
      while not end_of_file(fptr) loop
         -- Loop through characters until the character is not one of the following: ('!', '.', '?', ' ')
         loop
            --  get a character from the file
            get(fptr, ch);
  
            --  handle if the character is punctuation
            if(isPunc(ch)) then
               totalPunc := totalPunc + 1;
            end if;

            -- leave the loop when the character is not punctuation or a space  
            exit when ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ' and ch /= ' ' and ch /= ',';
         end loop;

         --  if the current character is not punctuation or space (a word begins)
         if ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ' and ch /= ',' then
            if (isLetter(ch)) then
               charsInWord := charsInWord + 1;
               wordsInSent := wordsInSent + 1;
               --  append characters to currWord
               tempStr(1) := ch;
               currWord := currWord & To_Unbounded_String(tempStr);

               --  loop until the end of the word
               loop
                  get(fptr, ch);
    
                  exit when not isLetter(ch);

                  --  handle if the character is a letter
                  if(isLetter(ch)) then
                     charsInWord := charsInWord + 1;
                     --  append characters to currWord
                     tempStr(1) := ch;
                     currWord := currWord & To_Unbounded_String(tempStr);
                  end if;
               end loop;

               --  check if this is the longest word
               if charsInWord > longestWord then
                  longestWord := charsInWord;
               end if;

               --  add the chars in word to total chars
               totalChars := totalChars + charsInWord;
               --  reset charsInWord
               charsInWord := 0;

               --  if the word only has alphabetic characters, append it to the word array
               if(isWord(to_string(currWord))) then
                  words(wordCount + 1) := currWord;
                  currWord := to_unbounded_string("");
                  wordCount := wordCount + 1;
               elsif(isNumber(to_string(currWord))) then
                  put_line("Warning: attempting to put a number into the words array");
               end if;

            --  handle if the character is a number
            elsif isNum(ch) then
               totalNumbers := totalNumbers + 1;
               totalChars := totalChars + 1;

               --  loop until the end of the number
               loop
                  get(fptr, ch);
        
                  exit when not isNum(ch);
                  totalChars := totalChars + 1;
               end loop;
            end if;

            --  handle if the character is punctuation
            if(isPunc(ch)) then
               totalPunc := totalPunc + 1;
            end if;  
            
         end if;

         --  check for the end of a sentence
         end_of_sent_check(ch, totalSents, totalWords, longestSent, wordsInSent);

         -- Loop until end of line or until the character is not one of the following: ('!', '.', '?', ' ')
         loop
            exit when end_of_line(fptr) or (ch = '!' or ch = '.' or ch = '?' or ch = ' ' or ch = ',');
            --  exit when ch /= '!' and ch /= '.' and ch /= '?' and ch /= ' ' and ch /= ',';
            get(fptr, ch);

            if isLetter(ch) then
               --  put(ch);
               charsInWord := charsInWord + 1;
               wordsInSent := wordsInSent + 1;
               --  append characters to currWord
               tempStr(1) := ch;
               currWord := currWord & To_Unbounded_String(tempStr);

               --  loop until the end of the word
               loop
                  get(fptr, ch);
                  exit when not isLetter(ch);
                  charsInWord := charsInWord + 1;
                  if(isLetter(ch)) then
                     charsInWord := charsInWord + 1;
                     --  append characters to currWord
                     tempStr(1) := ch;
                     currWord := currWord & To_Unbounded_String(tempStr);
                  end if;
               end loop;

               --  check if this is the longest word
               if charsInWord > longestWord then
                  longestWord := charsInWord;
               end if;

               --  reset charsInWord
               charsInWord := 0;

               exit; -- after looping through a word, exit the loop

            elsif isNum(ch) then
               totalNumbers := totalNumbers + 1;
               totalChars := totalChars + 1;

               --  loop until the end of the number
               loop
                  get(fptr, ch);
                  exit when not isNum(ch);
                  totalChars := totalChars + 1;
               end loop;

               exit; -- after looping through a number, exit the loop

            end if;
            
         end loop;
         
      end loop;

      -- close the file
      close(fptr);

      --  calculate averages
      avgChars := float(totalChars) / float(totalWords);
      avgWords := float(totalWords) / float(totalSents);

      --  output stats
      new_line;
      put_line("Statistics:");
      put_line("---------------------------");
      put_line("Character count: " & integer'image(totalChars));
      put_line("Word count: " & integer'image(totalWords));
      put_line("Sentence count: " & integer'image(totalSents));
      put_line("Number count: " & integer'image(totalNumbers));
      put_line("Punctuation count: " & integer'image(totalPunc));
      put_line("Longest word length: " & integer'image(longestWord));
      put_line("Longest sentence length: " & integer'image(longestSent));
      put_line("Characters per word: " & float'image(avgChars));
      put_line("Words per sentence: " & float'image(avgWords));

      --  print the histogram
      new_line;
      put_line("Histogram:");
      printHist(words, totalWords);

   end analyzeText;

   --  function that checks if a file with the filename exists
   function CheckFileExists(filename : unbounded_string) return boolean is
      filename_Str : constant String := to_string(filename);
   begin
      return Exists(filename_Str);
   end CheckFileExists;

   --  function to check if a character is punctuation
   function isPunc(ch : character) return boolean is
   begin
      case ch is
         when '.' | ',' | ';' | ':' | '?' | '!' | '-' | '\' | '"' | '(' | ')' | '[' | ']' | '{' | '}' =>
            return true;
         when others =>
            return false;
      end case;
   end isPunc;

   --  function to check if a character is a number
   function isNum(ch : character) return boolean is
   begin
      return ch in '0'..'9';
   end isNum;

   --  function to check if a character is a letter
   function isLetter(ch : character) return boolean is
   begin
      return ch in 'a'..'z' or ch in 'A'..'Z';
   end isLetter;

   --  function to count the number of spaces in the file
   function count_spaces_in_file(filename : unbounded_string) return integer is
      fptr : file_type;
      ch : character;
      space_count : integer := 0;
   begin
      open(fptr, in_file, to_string(filename));

      while not end_of_file(fptr) loop
         get(fptr, ch);
         if ch = ' ' then
            space_count := space_count + 1;
         end if;
      end loop;

      close(fptr);

      return space_count;

   end count_spaces_in_file;

   --  function to count the number of lines in the file
   function count_lines_in_file(filename : unbounded_string) return integer is
      fptr : file_type;
      count : integer := 0;
      temp : unbounded_string;
   begin
      open(fptr, in_file, to_string(filename));
      while not end_of_file(fptr) loop
         get_line(fptr, temp);
         count := count + 1;
      end loop;
      close(fptr);
      return count;
   end count_lines_in_file;

   --  function to check if the end of a sentence has been reached
   procedure end_of_sent_check(ch : in character; totalSents : in out integer; totalWords : in out integer; longestSent : in out integer; wordsInSent : in out integer) is
   begin
      if ch = '!' or ch = '.' or ch = '?' then
         totalSents := totalSents + 1;
         totalWords := totalWords + wordsInSent;
         if longestSent < wordsInSent then
            longestSent := wordsInSent;
         end if;
         wordsInSent := 0;
      end if;
   end end_of_sent_check;

   --  function to print a histogram of the length of the words
   procedure printHist(strings : string_array; totalWords: integer) is
      longest_length : natural := 0;
   begin
      -- find the longest length of the strings in the array
      for i in 1..totalWords loop
         if length(strings(i)) > longest_length then
            longest_length := length(strings(i));
         end if;
      end loop;

      -- print the histogram
      for Len in 1..longest_length loop
         Put(integer'image(Len));
         Put(": ");

         for I in strings'Range loop
            if Length(strings(I)) = Len then
               Put("*");
            end if;
         end loop;

         new_line;
      end loop;
   end printHist;

   --  function to check if a string only has alphabetic characters
   function isWord(Word : String) return Boolean is
      Is_All_Letters : Boolean := True;
   begin
      for I in Word'Range loop
         if not Ada.Characters.Handling.Is_Letter(Word(I)) then
            Is_All_Letters := False;
            exit;
         end if;
      end loop;
      
      return Is_All_Letters;
   end isWord;

   --  function to check if a string only has numeric characters
   function isNumber(num : String) return Boolean is
      Is_All_Numbers : Boolean := True;
   begin
      for I in num'Range loop
         if not Ada.Characters.Handling.Is_Digit(num(I)) then
            Is_All_Numbers := False;
            exit;
         end if;
      end loop;
      
      return Is_All_Numbers;
   end isNumber;

end textstats;
