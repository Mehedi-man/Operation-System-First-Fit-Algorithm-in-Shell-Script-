echo "=== First Fit Memory Allocation Simulator ==="
echo


echo -n "Enter the number of blocks: "
read nb


declare -a block_size
declare -a block_status   

echo "Enter the size of the blocks:"
for ((i=1; i<=nb; i++))
do
    echo -n "Block $i: "
    read size
    block_size[$i]=$size
    block_status[$i]=0   
done


echo
echo -n "Enter the number of files: "
read nf


declare -a file_size
declare -a allocation    

echo "Enter the size of the files:"
for ((i=1; i<=nf; i++))
do
    echo -n "File $i: "
    read size
    file_size[$i]=$size
    allocation[$i]=-1     
done

echo
echo "------------------------------------------------"
echo "Starting First Fit Allocation..."
echo "------------------------------------------------"

total_fragmentation=0

# 3. First Fit Allocation
for ((i=1; i<=nf; i++))
do
    allocated=false
    
    for ((j=1; j<=nb; j++))
    do
    
        if [ ${block_status[$j]} -eq 0 ] && [ ${block_size[$j]} -ge ${file_size[$i]} ]
        then
            allocation[$i]=$j
            block_status[$j]=1
            

            frag=$(( block_size[$j] - file_size[$i] ))
            total_fragmentation=$((total_fragmentation + frag))
            
            echo "File $i (${file_size[$i]} KB) → Allocated to Block $j (${block_size[$j]} KB)"
            echo "   Internal Fragmentation in this block: $frag KB"
            allocated=true
            break
        fi
    done
    
    if [ "$allocated" = false ]
    then
        echo "File $i (${file_size[$i]} KB) → Not allocated (no suitable block found)"
    fi
done

echo "------------------------------------------------"
echo "Final Allocation Summary:"
echo "------------------------------------------------"

for ((i=1; i<=nf; i++))
do
    if [ ${allocation[$i]} -ne -1 ]
    then
        echo "File $i → Block ${allocation[$i]}"
    else
        echo "File $i → Not Allocated"
    fi
done

echo
echo "Total External Fragmentation = $total_fragmentation KB"
echo
echo "Thank you!"
