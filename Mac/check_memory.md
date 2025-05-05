# How to check memory on mac via CLI?

```
#top -l 1 -s 0 | grep PhysMem
```

```
#top -l 1 -s 0 | grep PhysMem | sed 's/, /\n /g'
```

```
#vm_stat
```