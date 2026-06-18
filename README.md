# Example repo for terragrunt stack filter issue

## Test functionality run
```bash
cd stacks/first
terragrunt stack run apply
```

Should output both echo commands from the units

## Test filters
Dropping a few commads, outputs and my understanding of what they are doing. This is the part I think I need the most help on as I'm not sure if it's my syntax or a filter issue
```bash
terragrunt stack run --filter './stacks/first' -- apply

INFO   Generating unit module_2 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
WARN   No units discovered. Creating an empty runner.
INFO
```
understanding:
This seems to be running both the first and second stacks which I don't want, just want it to run first

```bash
terragrunt stack run --filter 'name=first' -- apply

INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/second/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
WARN   No units discovered. Creating an empty runner.
INFO
```
understanding:
Same thing as above.

```bash
terragrunt stack run --filter './stacks/first | type=stack' -- apply

INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
WARN   No units discovered. Creating an empty runner.
INFO
```
understanding:
This correctly generates the first stack, but does not generate the second stack or cooresponding units and does not fully apply

```bash
terragrunt stack run --filter 'name=first | type=stack' -- apply

INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
WARN   No units discovered. Creating an empty runner.
INFO
```
understanding: 
This seems to be running both the first and second stacks which I don't want, just want it to run first

The next few need to be ran in order
```bash
terragrunt stack generate --filter './stacks/first | type=stack'

INFO   Generating stack first from ./stacks/first/terragrunt.stack.hc

tree -a stacks/first
stacks/first
├── .terragrunt-stack
│   └── first
│       └── terragrunt.stack.hcl
└── terragrunt.stack.hcl
```
understanding: 
Generates the first and only the first stack, meaning the second is sitting in file system, seemingly like the run commands above

```bash
terragrunt stack generate --filter './stacks/first/** | type=stack'

INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
```
understanding: 
Generates the units from the secondary stack file

```bash
terragrunt run --all --filter './stacks/first/** | type=unit' -- apply
11:57:53.057 INFO   Generating stack first from ./stacks/first/terragrunt.stack.hcl
11:57:53.057 INFO   Generating unit module_2 from ./stacks/second/terragrunt.stack.hcl
11:57:53.057 INFO   Generating unit module_1 from ./stacks/second/terragrunt.stack.hcl
11:57:53.803 INFO   Generating unit module_2 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
11:57:53.803 INFO   Generating unit module_1 from ./stacks/first/.terragrunt-stack/first/terragrunt.stack.hcl
11:57:54.456 INFO   - Unit stacks/first/.terragrunt-stack/first/.terragrunt-stack/module_1
- Unit stacks/first/.terragrunt-stack/first/.terragrunt-stack/module_2

Are you sure you want to run 'terragrunt apply' in each unit of the run queue displayed above? (y/n)
```
understanding: 
The filter was ignored and it just ran everything inside the repository
