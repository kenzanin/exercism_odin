package protein_translation


get_amino_acid :: proc(codon: string) -> (amino_acid: string, valid: int) {
	switch codon {
	case "AUG":
		return "Methionine", 1
	case "UUU", "UUC":
		return "Phenylalanine", 1
	case "UUA", "UUG":
		return "Leucine", 1
	case "UCU", "UCC", "UCA", "UCG":
		return "Serine", 1
	case "UAU", "UAC":
		return "Tyrosine", 1
	case "UGU", "UGC":
		return "Cysteine", 1
	case "UGG":
		return "Tryptophan", 1
	case "UAA", "UAG", "UGA":
		return "STOP", 0
	case:
		return "Unknown", 2
	}
}

proteins :: proc(rna_strand: string) -> ([]string, bool) {
	if len(rna_strand) == 0 {
		return []string{}, true
	}

	result := [dynamic]string{}
	for i := 0; i < len(rna_strand); i += 3 {
		if (i + 3) > len(rna_strand) {
			return nil, false
		}
		codon := rna_strand[i:i + 3]
		acid, ok := get_amino_acid(codon)

		if ok == 0 {
			break
		}

		if ok != 1 {
			return nil, false
		}

		append(&result, acid)
	}

	return result[:], true
}
