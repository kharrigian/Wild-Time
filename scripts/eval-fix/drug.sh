#CORAL
python main.py --dataset=drug --method=coral --offline --lr=5e-5 --split_time=2016 --num_groups=3 --group_size=2  --coral_lambda=0.9 --mini_batch_size=256 --train_update_iter=5000 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#GroupDRO
python main.py --dataset=drug --method=groupdro --offline --split_time=2016 --num_groups=3 --group_size=2 --mini_batch_size=256 --train_update_iter=5000 --lr=2e-5 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#IRM
python main.py --dataset=drug  --method=irm --offline --irm_lambda=1e-3 --irm_penalty_anneal_iters=0 --split_time=2016 --num_groups=3 --group_size=2 --mini_batch_size=256 --train_update_iter=5000 --lr=2e-5 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#ERM
python main.py --dataset=drug --method=erm --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#Task Difficulty
python main.py --dataset=drug --method=erm --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA --difficulty

#Mixup
python main.py --dataset=drug --method=erm --mixup --mix_alpha=2.0 --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#A-GEM
python main.py --dataset=drug --method=agem --buffer_size=1000 --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#EWC
python main.py --dataset=drug --method=ewc --ewc_lambda=0.5 --online --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#Fine-tuning
python main.py --dataset=drug --method=ft --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#SI
python main.py --dataset=drug --method=si --si_c=0.1 --epsilon=0.001 --offline --lr=5e-5 --mini_batch_size=256 --train_update_iter=5000 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA
