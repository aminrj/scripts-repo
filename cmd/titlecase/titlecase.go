package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"

    "golang.org/x/text/cases"
    "golang.org/x/text/language"
)

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    titleCaser := cases.Title(language.Und) // 'Und' is the "undetermined" locale

    for scanner.Scan() {
        line := scanner.Text()

        // Split, apply Title, rejoin
        words := strings.Fields(line)
        for i, w := range words {
            words[i] = titleCaser.String(w)
        }
        fmt.Println(strings.Join(words, " "))
    }

    if err := scanner.Err(); err != nil {
        fmt.Fprintln(os.Stderr, "Error reading stdin:", err)
        os.Exit(1)
    }
}

