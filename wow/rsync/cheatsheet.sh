LHS=Kugraza
RHS=還活著
sed -i "s/${LHS}/${RHS}/g" `grep ${LHS} -rl .`
