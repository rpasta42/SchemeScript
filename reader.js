
function conf() {
   //( ) { } [ ] ' , "
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
   var ranges = [];

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



      }


   }

}

function lex(var str) {

}

function parse(lexemes) {


}
