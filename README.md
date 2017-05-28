# Grep fasta

Grep sequences from a fasta file.

## Installation

Requires the Chicken Scheme compiler. If you don't have it, you can use the pre-compiled binaries.

### From source

Get the source code, either with `git clone` or download a release.

In the main source directory, run `make` and optionally `make install`.

## Usage

```
grep_fasta [-e] pattern seqs.fa > subset.fa
```

- Pass the `-e` flag to specify exact string matching. Else, regular expression matching is used.
- `pattern` is either a string for exact matching or a regular expression
- `seqs.fa` is a fastA file

### Example

Running `grep_fasta ^apple seqs.fa > subset.fa` would print all sequences that start with `apple` in the header.
