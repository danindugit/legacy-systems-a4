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

   function CheckFileExists(filename : in Unbounded_String) return boolean is
      filename_Str : constant String := to_string(filename);
   begin
      return Exists(filename_Str);
   end CheckFileExists;


end textStats;
