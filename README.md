# Ticketfly Clone Script

Are you working on a giant venue and need to make a whole bunch of identical section? Maybe even hundreds or thousands?

This tool allows you to procedurally generate sections, while paiting price levels and holds correctly onto each seat. This is really useful for testing or bulk reserved template generation.

## Usage

1. Create a new venue template (or modify an existing one) with at least one of each section you need to be cloned.
1. Download the JSON file of that template.
1. Run the script

`$ ruby generator.rb path/to/TEMPLATE.json`

You'll be presented a list of templates and asked which tempalte you want to clone, how many times, etc. The script will copy any holds applied, and also increment sections by name (and selling order) automatically.

After each section completes cloning you'll be asked if you want to add any more, or type "done" to say you are finished. Only when you type "done" is the output file updated.

Note: template sections are included in the final output file.
