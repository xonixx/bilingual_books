BEGIN {
    PdfLeft  = ARGV[1]
    PdfRight = ARGV[2]
    print "Will join '" PdfLeft "' and '" PdfRight "'..."
    "pdftk " PdfLeft " dumpdata | grep NumberOfPages" | getline
    NumberOfPages = $2
    print "Number of pages: " NumberOfPages
    explodeToPages(PdfLeft)
    explodeToPages(PdfRight)

    cmd = "pdftk "
    cleanup = "rm "
    for (i=1; i<=NumberOfPages; i++) {
        pdf2 = sprintf("%s-%d.pdf %s-%d.pdf ", PdfLeft, i, PdfRight, i)
        cmd = cmd pdf2
        cleanup = cleanup pdf2
    }
    cmd = cmd "cat output combined.pdf"
    printf "%s", "Building combined.pdf..."
#    print cmd
    runOrError(cmd)
    print " done."

    printf "%s", "Cleanup..."
    runOrError(cleanup)
    print " done."
}

function explodeToPages(file) {
    printf "%s", "Exploding to pages: '" file "'..."
    runOrError("pdftk '" file "' burst output '" file "-%d.pdf'")
    print " done."
}

function runOrError(cmd) {
    if (system(cmd) == 0) { close(cmd); return }
    print "error running: " cmd >> "/dev/stderr"
    exit 1
}
