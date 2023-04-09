--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with textstats; use textstats;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure textyzer is
   filename : unbounded_string;
   totalSpaces : integer;
   totalLines : integer;
begin
   --  get the file name
   getFilename(filename);
   
   --  count spaces + lines in the file
   totalSpaces := count_spaces_in_file(filename);
   totalLines := count_lines_in_file(filename);

   --  analyze the text
   analyzeText(filename, totalSpaces + totalLines);
end textyzer;