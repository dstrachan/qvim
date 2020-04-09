dir:` sv(`$":",getenv`HOME),`.vim`syntax
kFile:` sv dir,`k.vim
if[not kFile~key kFile;
  exit 1];
qFile:` sv dir,`q.vim
if[not qFile~key qFile;
  exit 1];

extraPrimitives:`by`from
extraFuncs:`.Q.pf`.Q.vp`.Q.x

getFuncs:{[namespace]
  ` sv'namespace,/:1_key namespace}

kPrimitiveHead:"syn keyword kPrimitive "
kPrimitives:kPrimitiveHead,/:string asc distinct .Q.res,extraPrimitives

qLibHead:"syn keyword qLib "
qLibs:qLibHead,/:ssr[;".";"\\."]@'string asc distinct extraFuncs,raze getFuncs'[` sv'`,/:key`]

qFunctionHead:"syn keyword qFunction "
qFunctions:qFunctionHead,/:string asc distinct 1_key`.q

getContents:{[d]
  i:til count contents;
  f:first values:value d;
  l:last values;
  head:contents f[0]#i;
  middle:contents 1_(l[0]-f 1)#f[1]_i;
  tail:contents 1_l[1]_i;
  res:head,value[first key d],$[f~l;();middle,value[last key d]],tail;
  res}

// kFile
contents:read0 kFile
kPrimIndex:where contents like kPrimitiveHead,"*"
qLibIndex:where contents like qLibHead,"*"
kFile 0:getContents(min;max)@\:/:asc`kPrimitives`qLibs!(kPrimIndex;qLibIndex)

// qFile
contents:read0 qFile
qFuncIndex:where contents like qFunctionHead,"*"
qFile 0:getContents(min;max)@\:/:asc enlist[`qFunctions]!enlist qFuncIndex
\\
