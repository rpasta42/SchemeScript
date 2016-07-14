function ss_get_val(x) { //TODO: check for other stuff like pair
   if (x.ss_type != undefined && x.ss_type != SS_ERR)
      return x.value;
   return null;
}
function ss_mk_var(type, val) {
   var v = {};
   v.ss_type = type;
   if (val != undefined)
      v.value = val;
   return v;
}
function ss_mk_err(code, start, end) {
   var err = ss_mk_var(SS_ERR);
   err.code = code;
   err.start = start;
   err.end = end;
   return err;
}
function ss_is_type(val, t) {
   if (typeof val === 'object' && val.ss_type != undefined) {
      return val.ss_type == t;
   }
}

//Error types
var SS_ERR_UnterminatedComment = -42;
var SS_ERR_UnterminatedQuote = -41;
var SS_ERR_MisformedNum = -40;
var SS_ERR_UnknownLexBlock = -39;

//variable types
var SS_LEX = 'ss_lex';
var SS_STR = 'ss_str';
var SS_NUM = 'ss_num';
var SS_SYM = 'ss_sym';
var SS_FUN = 'ss_fun';
var SS_ERR = 'ss_err';
var SS_LST = 'ss_lst';
var SS_ARR = 'ss_arr';
var SS_CON = 'ss_con';

function conf() {
   //( ) { } [ ] ' , "

   //o_paren, c_paren, o_square_br, c_square_br
   //var lexemeTypes = ['sym', 'num', 'str', 'paren', 'quote', 'comment'];
   //this.lexemeTypes = lexemeTypes;
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

   if (cmnt_start != null)
      return ss_mk_err(SS_ERR_UnterminatedComment, cmnt_start, code.length - 1);
   if (str_start != null)
      return ss_mk_err(SS_ERR_UnterminatedQuote, str_start, code.length - 1);
   return ss_mk_var(SS_ARR, blk_ranges);
}

//Lexeme types
var SS_LEX_STR = 'ss_lex_str';
var SS_LEX_INT = 'ss_lex_int';
var SS_LEX_FLT = 'ss_lex_flt'; //float
var SS_LEX_SYM = 'ss_lex_sym';
var SS_LEX_O_P = 'ss_lex_o_p'; // (
var SS_LEX_C_P = 'ss_lex_c_p'; // )
var SS_LEX_O_S = 'ss_lex_o_s'; // [
var SS_LEX_C_S = 'ss_lex_c_s'; // ] close square
/*var SS_LEX_Q   = 'ss_lex_q'; // '
var SS_LEX_QQ  = 'ss_lex_qq';  // ` (quasiquote/backquote)
var SS_LEX_CMA = 'ss_lex_cma'; // , (comma)*/
var SS_LEX_Q   = 'ss_lex_\'';  // '
var SS_LEX_QQ  = 'ss_lex_`';   // ` (quasiquote/backquote)
var SS_LEX_CMA = 'ss_lex_,';   // , (comma)
var SS_LEX_SC  = 'ss_lex_sc';  // ; (simple comment that spawns until end of line)
var SS_LEX_BC  = 'ss_lex_bc';  // #| and |# (block comment)

function make_lexeme(type, val) { return ss_mk_var(SS_LEX, val); }
function make_lexeme_range(type, val, start, end) {
   return {'lexeme': make_lexeme(type, val), 'start': start, 'end': end};
}
function add_lex_range(lex, start, end) {
   return {'lexeme': lex, 'start': start, 'end': end};
}

function collect_sym(col) {
   if (is_int(col))
      return make_lexeme(SS_LEX_INT, parseInt(col));
   if (is_float(col))
      return make_lexeme(SS_LEX_FLT, parseFloat(col));
   if (is_number_like(col)) // 2dsfsd 4dsf is not allowed
      return null;
   return make_lexeme(SS_LEX_SYM, col);
}

function lex(str) {
   var lexemes = [];
   var col = ''; //symbol collector

   //range of comments/string blocks
   var block_ranges_ret = _get_block_ranges(str);
   if (ss_is_type(block_ranges_ret, SS_ERR)) return block_ranges_ret;

   var block_ranges = ss_get_val(block_ranges_ret);
   var br_it = 0; //current string/comment range
   var i = 0;
   var collect_start = 0, collect_end = 0;

   while (i < str.length) {
      //var is_block_start = br_it < block_ranges.length && block_ranges[br_it].start == i;

      //block != null if haven't looped through all blocks, and i is beginning of block
      var block = br_it < block_ranges.length ? block_ranges[br_it] : null;
      block = (block.start == i) ? block : null;

      //if current char c is string or special char, then push previously collected
      var c = str[i];
      var special_chars = [' ', '(', ')', '\'', '`', ',', '[', ']', '{', '}'];
      var is_c_special = (block != null) || contains(special_chars, c);

      //current is special, so push previously collected numberes and symbols
      if (is_c_special && !(col.length == 0)) {
         var lexeme = collect_sym(col);
         if (lexeme == null)
            return ss_mk_err(SS_ERR_MisformedNum, collect_start, collect_end);
         else
            lexemes.push(add_lex_range(lexeme, collect_start, collect_end));
         col = '';
      }
      if (block != null) { //push strings and comments if we have any
         var block_lexeme = null;

         switch (block.type) { //'str' or ';' or '#|'
            case 'str':
               var slice = str.slice(block.start+1, block.end-1);
               block_lexeme = make_lexeme(SS_LEX_STR, slice);
            break;
            case '#|':
               var slice = str.slice(block.start+2, block.end-2);
               block_lexeme = make_lexeme(SS_LEX_BC, slice);
            break;
            case ';':
               var slice = str.slice(block.start+1, block.end-1);
               block_lexeme = make_lexeme(SS_LEX_SC, slice);
            break;
         }

         if (block_lexeme == null)
            return ss_mk_err(SS_ERR_UnknownLexBlock, block.start, block.end);
         lexemes.push(add_lex_range(block_lexeme, block.start, block.end));
         i = block.end + 1; //TODO: maybe continue
         br_it += 1; //next block range
      }
      if (str[i] != undefined) {
         c = str[i];
         if (contains([',', '`', '\'', '(', ')', '[', ']', '{', '}'], c
         if (c == ',' || c == '`' || c == '\'') {
            //let q = make_lexeme('ss_lex_' + c, null);
            //lexemes.push(add_lex_range(q, i, i));
            lexemes.push(make_lexeme_range('ss_lex_' + c, null, i, i));
         }
         else if (c == '(')
            lexemes.push(make_lexeme_range(SS_LEX_O_P, null, i, i));
         else if (c == ')')
            lexemes.push(make_lexeme_range(SS_LEX_C_P, null, i, i));
         else if (c == '[')
      }
   }
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

//MISC Generic Helper Utilities
function is_int(x) {
   var str = x.toString();
   return is_numeric(str) && str.indexOf('.') == -1;
}
function is_float(x) {
   var str = x.toString();
   return is_numeric(str) && str.indexOf('.') != -1;
}
function is_number_like(str) { return str.length > 0 && !isNaN(str[0]); } //TODO
function is_numeric(str) { return !isNaN(str); } //TODO
function to_num(str) { return parseFloat(str); } //TODO

//http://stackoverflow.com/questions/1181575/determine-whether-an-array-contains-a-value
var _contains = function(needle) {
   // Per spec, the way to identify NaN is that it is not equal to itself
   var findNaN = needle !== needle;
   var indexOf;

   if(!findNaN && typeof Array.prototype.indexOf === 'function') {
      indexOf = Array.prototype.indexOf;
   } else {
      indexOf = function(needle) {
         var i = -1, index = -1;

         for(i = 0; i < this.length; i++) {
            var item = this[i];

            if((findNaN && item !== item) || item === needle) {
               index = i;
               break;
            }
         }

         return index;
      };
   }

   return indexOf.call(this, needle) > -1;
};
function contains(arr, needle) {
   return _contains.call(arr, needle);
}

