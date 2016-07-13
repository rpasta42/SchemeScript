
var SS_STR = 'ss_str';
var SS_NUM = 'ss_num';
var SS_SYM = 'ss_sym';


function ss_mk_type(type) {
   var v = {};
   v.ss_type = type;

}

function conf() {
   //( ) { } [ ] ' , "

   //o_paren, c_paren, o_square_br, c_square_br
   var lexemeTypes = ['sym', 'num', 'str', 'paren', 'quote', 'comment'];
   this.lexemeTypes = lexemeTypes;
   return this;
}

var c = conf();

//internal lexer function
//Block is a lexeme type which stores parts of
//code that don't get parsed but just get stored
//as a string. Currently, blocks include strings
//and single & multi-line comments.
//Note: parenthesis don't count as blocks
function _lex_get_block_ranges(str) {
   //blk type = 'str'|';'|'#|'
   function mk_blk(type, start, end) {
      var ret = {};
      ret.start = start;
      ret.end = end;
      ret.type = type;
      return ret;
   }

   var blk_ranges = [];

   var cmnt_start = null;
   var str_start = null;

   var multi_first_char = false; //multiline comment
   var escape = false;

   //index in str where current line starts (which is length of previous line)
   var line_start = 0;
   var lines = str.split('\n');

   for (var lineNum in lines) {
      var line = lines[lineNum];
      var line_end = line_start + line.length;

      for (var i = 0; i < line.length; i++) {
         var c = line[i];
         var real_i = line_start + i; //index into str of current char

         if (escape) { escape = false; continue; }

         if (c == '\\' && str_start != null) {
            escape = true;
         }
         else if (c == '"' && cmnt_start == null) {
            if (str_start == null)
               str_start = real_i;
            else {
               blk_ranges.push(mk_blk('str', str_start, real_i));
               str_start = null;
            }
         }
         else if (c == ';' && cmnt_start == null && str_start == null) {
            blk_ranges.push(mk_blk(';', real_i, line_end));
            break; //go to next line
         }
         else if (c == '|' && str_start == null) {
            if (cmnt_start == null && multi_first_char) {
               cmnt_start = real_i-1;
            } else {
               multi_first_char = true;
               continue;
            }
         }
         else if (c == '#' && str_start == null) {
            if (cmnt_start == null) {
               multi_first_char = true;
               continue;
            }
            else if (multi_first_char) {
               blk_ranges.push(mk_blk('#|', cmnt_start, real_i));
               cmnt_start = null;
            }
         }

         multi_first_char = false;
      }

      line_start = line_end;
   }

   if (cmnt_start != null) {
      return
   }

   return blk_ranges;
}

function lex(str) {

}

function parse(lexemes) {
}

function test_lex_get_block_ranges() {
   //TODO: test each block type as beginning/end of line/file for each one
   var test_lex_str1 = "\"hello ;world\";test\n f #|yo|#"; //one string, 1 1-line comment, 1 multi-line
   var test_lex_str2 = "\"\"\"\" ;\n\n #||##|\n|#"; //2 strings, 2 1-line comments, 2 multi-line comments
   var test_lex_str3 = "\"h#| |#ello ;\"blah;test\nf#|y;o|#"; //1 string, 1 1-line, 1 multi-line
   var test_lex_str4 = "\"h#| |#ello ;\"\"world\";test\nf#|y;\no|#"; //

   console.log(_lex_get_block_ranges(test_lex_str3))
}

function main() {
   test_lex_get_block_ranges();

}

main();
