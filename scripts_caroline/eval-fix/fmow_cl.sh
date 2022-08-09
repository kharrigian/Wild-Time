#!/bin/bash
#SBATCH --partition=iris-hi # Run on IRIS nodes
#SBATCH --time=120:00:00 # Max job length is 5 days
#SBATCH --nodes=1 # Only use one node (machine)
#SBATCH --mem=64G # Request 16GB of memory
#SBATCH --gres=gpu:1 # Request one GPU
#SBATCH --job-name="fmow-eval-fix" # Name the job (for easier monitoring)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=cchoi1@stanford.edu     # Where to send mail

# Now your Python or general experiment/job runner code
source /iris/u/huaxiu/venvnew/bin/activate

cd ../..

python main.py --dataset=fmow --method=agem --buffer_size=1000 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=1
python main.py --dataset=fmow --method=agem --buffer_size=1000 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=2
python main.py --dataset=fmow --method=agem --buffer_size=1000 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=3

python main.py --dataset=fmow --method=ewc --ewc_lambda=0.5 --online --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=1
python main.py --dataset=fmow --method=ewc --ewc_lambda=0.5 --online --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=2
python main.py --dataset=fmow --method=ewc --ewc_lambda=0.5 --online --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=3

python main.py --dataset=fmow --method=ft --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=1
python main.py --dataset=fmow --method=ft --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=2
python main.py --dataset=fmow --method=ft --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=3

python main.py --dataset=fmow --method=si --si_c=0.1 --epsilon=0.001 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=1
python main.py --dataset=fmow --method=si --si_c=0.1 --epsilon=0.001 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=2
python main.py --dataset=fmow --method=si --si_c=0.1 --epsilon=0.001 --mini_batch_size=64 --train_update_iter=500 --lr=1e-4 --weight_decay=0.0 --offline --split_time=10 --random_seed=3