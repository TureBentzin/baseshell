# Baseshell
This flake provides two devshells that can be used via flake-url.

The devshells are shipped with [fish](https://fishshell.com/)

## baseshell-default

The default baseshell.  
It contains:

- fish  
- gitFull  
- nano  
- helix  
- vim  
- htop  
- btop  
- direnv  
- tree  
- openssh  

Enter this shell running:

```bash
nix develop github:TureBentzin/baseshell
````

or using fish (recommended):

```bash
nix develop github:TureBentzin/baseshell -c fish
```

## baseshell-minimal

A minimal baseshell.
It contains:

* fish
* helix
* htop
* git
* direnv
* tree
* openssh

Enter this shell running:

```bash
nix develop github:TureBentzin/baseshell#minimal
```

or using fish (recommended):

```bash
nix develop github:TureBentzin/baseshell#minimal -c fish
```

## usage of direnv

Please make sure to follow the [official hooking guide](https://direnv.net/docs/hook.html#fish) for direnv.
