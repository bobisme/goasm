// This is generated via `go tool compile -S sum.go`
	// 0x0000 00000 (sum.go:3)	TEXT	"".sum_go(SB), $0-32
	// 0x0000 00000 (sum.go:3)	FUNCDATA	$0, gclocals·42de96b0ee2ecebee32eb4aae6bc10d1(SB)
	// 0x0000 00000 (sum.go:3)	FUNCDATA	$1, gclocals·33cdeccccebe80329f1fdbee7f5874cb(SB)
	// 0x0000 00000 (sum.go:5)	MOVQ	"".a+16(FP), AX
	// 0x0005 00005 (sum.go:5)	MOVQ	"".a+8(FP), CX
	// 0x000a 00010 (sum.go:3)	MOVQ	$0, DX
	// 0x000c 00012 (sum.go:8)	MOVQ	DX, BX
	// 0x000f 00015 (sum.go:5)	CMPQ	DX, AX
	// 0x0012 00018 (sum.go:5)	JGE	$0, 41
	// 0x0014 00020 (sum.go:5)	LEAQ	1(CX), SI
	// 0x0018 00024 (sum.go:5)	INCQ	DX
	// 0x001b 00027 (sum.go:6)	MOVBLZX	(CX), DI
	// 0x001e 00030 (sum.go:6)	ADDQ	DI, BX
	// 0x0021 00033 (sum.go:5)	MOVQ	SI, CX
	// 0x0024 00036 (sum.go:5)	CMPQ	DX, AX
	// 0x0027 00039 (sum.go:5)	JLT	$0, 20
	// 0x0029 00041 (sum.go:8)	MOVQ	BX, "".~r1+32(FP)
	// 0x002e 00046 (sum.go:8)	RET

// Slice internals:
	// type slice struct {
	// 	array unsafe.Pointer
	// 	len   int
	// 	cap   int
	// }
	// https://sourcegraph.com/github.com/golang/go@31b2c4cc255b98e4255854a008c0c9b53ad4fd26/-/blob/src/runtime/slice.go#L11-12
	// unsafe.Pointer is an alias to an int
	// https://sourcegraph.com/github.com/golang/go@31b2c4cc255b98e4255854a008c0c9b53ad4fd26/-/blob/src/unsafe/unsafe.go#L15:6

// func sum(a []byte) int
TEXT ·sum(SB),$0-24
	// AX = len(a)
	// Take the Frame Pointer: FP
	// Get the value of it: (FP)
	// Move +8 bytes away: +8(FP)
	// Copy 8 bytes: MOVQ
	// Into register AX
	// AX will track our iterations.
	MOVQ a+8(FP), AX
	// Copy the pointer of byte slice |a| to CX.
	MOVQ a+0(FP), CX
	// The cap of byte slice |a| is *not* copied because it's unused.
	// Otherwise it would be: MOVQ a+16(FP),__

	// BX is the running total
	// BX = 0
	MOVL $0, BX
	// CX++ // since we decr at the start of every loop
	INCQ AX
loop:
	// Decrement the iterator.
	// AX--
	DECQ AX
	// If AX == 0, jump to `done`
	JZ done
	// Add the value to the running total.
	// BX += DI
	ADDL (CX), BX
	// Advance the pointer.
	// CX++
	INCQ CX
	JMP loop
done:
	// Expand to fill 8-bytes.
	MOVBLZX BX, BX
	// Set the total (BX) back on the frame pointer but after all the arguments.
	// A slice is 3 64-bit integers: pointer, len, cap (24-bytes, total).
	// The input slice is the only argument.
	// So we copy the value after 24 bytes.
	MOVQ BX, ret+24(FP)
	// Return.
	RET

// func sum(a []byte) int
TEXT ·sumold(SB),$0-24
	// AX = len(a)
	// Take the Frame Pointer: FP
	// Get the value of it: (FP)
	// Move +8 bytes away: +8(FP)
	// Copy 8 bytes: MOVQ
	// Into register AX
	MOVQ a+8(FP), AX
	// Copy the pointer of byte slice |a| to CX.
	MOVQ a+0(FP), CX
	// The cap of byte slice |a| is *not* copied because it's unused.
	// Otherwise it would be: MOVQ a+16(FP),__

	// DX = 0
	// DX is our iterator: for DX := 0; DX < AX; DX++
	MOVQ $0, DX
	// BX = 0
	MOVQ $0, BX
loop:
	// Compare DX to AX
	CMPQ DX, AX
	// If DX >= AX, jump to `done`
	JGE done
	// Set SI to the address of the *next* byte.
	// Take the value pointed to by CX: (CX)
	// Move 1 byte: 1(CX)
	// Get the address of that: LEAQ
	// COPY it to SI
	LEAQ 1(CX), SI
	// DX++
	INCQ DX
	// Expand the value of byte from 8-bits to 64-bits and move it into DI.
	// DI = int(*CX)
	MOVBLZX (CX), DI
	// Add the value to the running total.
	// BX += DI
	ADDQ DI, BX
	// CX = SI where SI is the pointer to the current byte.
	MOVQ SI, CX
	// Compare DX to AX
	CMPQ DX, AX
	// If DX < AX jump to `loop`.
	JLT loop
done:
	// Set the total (BX) back on the frame pointer but after all the arguments.
	// A slice is 3 64-bit integers: pointer, len, cap (24-bytes, total).
	// The input slice is the only argument.
	// So we copy the value after 24 bytes.
	MOVQ BX, ret+24(FP)
	// Return.
	RET
