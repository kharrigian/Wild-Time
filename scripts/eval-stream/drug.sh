#CORAL
python main.py --dataset=drug --method=coral --lr=5e-5 --split_time=2016 --num_groups=3 --group_size=2  --coral_lambda=0.9 --eval_next_timesteps=3 --mini_batch_size=256 --train_update_iter=500 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#GroupDRO
python main.py --dataset=drug --method=groupdro --split_time=2016 --num_groups=3 --group_size=2 --eval_next_timesteps=3 --mini_batch_size=256 --train_update_iter=500 --lr=2e-5 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#IRM
python main.py --dataset=drug  --method=irm --irm_lambda=1e-3 --irm_penalty_anneal_iters=0 --split_time=2016 --num_groups=3 --group_size=2 --eval_next_timesteps=3 --mini_batch_size=256 --train_update_iter=500 --lr=2e-5 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#ERM
python main.py --dataset=drug --method=erm --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#mixup
python main.py --dataset=drug --method=erm --mixup --mix_alpha=2.0 --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#A-GEM
python main.py --dataset=drug --method=agem --buffer_size=1000 --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#EWC
python main.py --dataset=drug --method=ewc --ewc_lambda=0.5 --online --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#Fine-tuning
python main.py --dataset=drug --method=ft --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500--split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA

#SI
python main.py --dataset=drug --method=si --si_c=0.1 --epsilon=0.001 --eval_next_timesteps=3 --lr=5e-5 --mini_batch_size=256 --train_update_iter=500 --split_time=2016 --random_seed=1 --log_dir=./checkpoints --data_dir=./raw-data/Drug-BA
