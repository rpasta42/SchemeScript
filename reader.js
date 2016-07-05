
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
function _lex_get_block_ranges(var str) {
   function mk_blk(start, end, type, extra) {
      var ret = {};
      ret.start = start;
      ret.end = end;
      ret.type = type;
      if (extra != null)
         ret.extra = extra;
      return ret;
   }

   //open = true|false, paren_type = '('|'{'|'['
   function mk_paren_extra(open, paren_type) {

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
            blk_ranges.push(mk_blk('comment',


         }

      }
   }

}

function lex(var str) {

}

function parse(lexemes) {


}
