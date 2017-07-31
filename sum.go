package sum

func sum_noasm(a []byte) int {
	total := uint8(0)
	for _, x := range a {
		total += x
	}
	return int(total)
}

func sum(a []byte) int
