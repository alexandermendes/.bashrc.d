# .bashrc.d

Clone:

```
git clone https://github.com/alexandermendes/.bashrc.d ~/.bashrc.d
```

Set permissions:

```
chmod 700 ~/.bashrc.d
```

Add the code below to the top of your `~/.bash_profile`.

```bash
for file in ~/.bashrc.d/*.bashrc;
do
 source "$file"
done
```

Install requirements:

```
brew update
brew install autojump
brew install jq
```

Source:

```
. ~/.bash_profile
```
