package reverse_string

import "core:strings"
import "core:unicode/utf8"

reverse :: proc(str: string) -> string {
	graphemes, graphemes_cnt, _, _ := utf8.decode_grapheme_clusters(str)
	defer delete(graphemes)
	sb := strings.builder_make()
	if graphemes_cnt != 0 {
		strings.write_string(&sb, str[graphemes[graphemes_cnt - 1].byte_index:])
	}
	for i := graphemes_cnt - 1; 1 <= i; i -= 1 {
		curr_idx := graphemes[i].byte_index
		prev_idx := graphemes[i - 1].byte_index
		strings.write_string(&sb, str[prev_idx:curr_idx])
	}
	return strings.to_string(sb)
}
