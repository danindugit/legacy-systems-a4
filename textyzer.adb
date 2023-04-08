--  Name: Danindu Marasinghe
--  Student ID: 1093791
--  Course: CIS*3190

with textStats; use textStats;
--  with Ada.Text_IO; use Ada.Text_IO; -- for I/O operations
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

procedure textyzer is
   filename : unbounded_string;
begin
   getFilename(filename);
   put(filename);
end textyzer;