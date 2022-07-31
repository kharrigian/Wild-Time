from collections import defaultdict

import os
import numpy as np
import pickle
import torch
from wilds import get_dataset

from data.utils import Mode

ID_HELD_OUT = 0.1


def get_image_idxs_and_labels(split: str, data_dir: str):
    dataset = get_dataset(dataset="fmow", root_dir=data_dir, download=True)
    split_array = dataset.split_array
    split_dict = dataset.split_dict

    y_array = []

    split_mask = split_array == split_dict[split]
    split_idx = np.where(split_mask)[0]
    y_array.append(dataset.y_array[split_idx])
    years = dataset.metadata_array[split_idx, 1]
    split_unique_years = torch.unique(years).detach().numpy().tolist()
    print(split, split_unique_years)

    image_idxs = defaultdict(list)
    labels = defaultdict(list)
    for year in split_unique_years:
        image_idxs[year].append(dataset.full_idxs[split_idx][torch.where(years == year)])
        labels[year].append(dataset.y_array[split_idx][torch.where(years == year)])

    return image_idxs, labels


def get_train_test_split(image_idxs_year, labels_year):
    num_samples = len(labels_year)
    num_train_samples = int((1 - ID_HELD_OUT) * num_samples)
    seed_ = np.random.get_state()
    np.random.seed(0)
    idxs = np.random.permutation(np.arange(num_samples))
    np.random.set_state(seed_)
    train_image_idxs = image_idxs_year[idxs[:num_train_samples]]
    train_labels = labels_year[idxs[:num_train_samples]]
    test_image_idxs = image_idxs_year[idxs[num_train_samples:]]
    test_labels = labels_year[idxs[num_train_samples:]]

    print(type(train_image_idxs), type(train_labels))

    return train_image_idxs, train_labels, test_image_idxs, test_labels


def preprocess(args):
    # FMoW Split Setup
    # train: 2002 - 2013
    # val_id: 2002 - 2013
    # test_id: 2002 - 2013
    # val_ood: 2013 - 2016
    # test_ood: 2016 - 2018
    # self._split_names = {'train': 'Train', 'id_val': 'ID Val', 'id_test': 'ID Test', 'val': 'OOD Val', 'test': 'OOD Test'}
    datasets = {}
    train_image_idxs, train_labels = get_image_idxs_and_labels('train', args.data_dir)
    val_image_idxs, val_labels = get_image_idxs_and_labels('id_val', args.data_dir)
    test_id_image_idxs, test_id_labels = get_image_idxs_and_labels('id_test', args.data_dir)

    # ID Years (2002 - 2013)
    for year in range(0, 11):
        datasets[year] = {}
        datasets[year][Mode.TRAIN] = {}
        datasets[year][Mode.TEST_ID] = {}
        datasets[year][Mode.TEST_OOD] = {}

        # import pdb;
        # pdb.set_trace()
        datasets[year][Mode.TRAIN]['image_idxs'] = np.concatenate((train_image_idxs[year][0], val_image_idxs[year][0]), axis=0)
        datasets[year][Mode.TRAIN]['labels'] = np.concatenate((train_labels[year][0], val_labels[year][0]), axis=0)
        datasets[year][Mode.TEST_ID]['image_idxs'] = np.array(test_id_image_idxs[year][0])
        datasets[year][Mode.TEST_ID]['labels'] = np.array(test_id_labels[year][0])
        datasets[year][Mode.TEST_OOD]['image_idxs'] = np.concatenate((datasets[year][Mode.TRAIN]['image_idxs'], datasets[year][Mode.TEST_ID]['image_idxs']), axis=0)
        datasets[year][Mode.TEST_OOD]['labels'] = np.concatenate((datasets[year][Mode.TRAIN]['labels'], datasets[year][Mode.TEST_ID]['labels']), axis=0)
    del train_image_idxs, train_labels, val_image_idxs, val_labels, test_id_image_idxs, test_id_labels

    # OOD Years (2013 - 2018)
    val_ood_image_idxs, val_ood_labels = get_image_idxs_and_labels('val', args.data_dir)
    for year in range(11, 14):
        datasets[year] = {}
        datasets[year][Mode.TRAIN] = {}
        datasets[year][Mode.TEST_ID] = {}
        datasets[year][Mode.TEST_OOD] = {}

        train_image_idxs, train_labels, test_image_idxs, test_labels = get_train_test_split(val_ood_image_idxs[year][0], val_ood_labels[year][0])
        datasets[year][Mode.TRAIN]['image_idxs'] = train_image_idxs
        datasets[year][Mode.TRAIN]['labels'] = train_labels
        datasets[year][Mode.TEST_ID]['image_idxs'] = test_image_idxs
        datasets[year][Mode.TEST_ID]['labels'] = test_labels
        datasets[year][Mode.TEST_OOD]['image_idxs'] = val_ood_image_idxs[year][0]
        datasets[year][Mode.TEST_OOD]['labels'] = val_ood_labels[year][0]
        del train_image_idxs, train_labels, test_image_idxs, test_labels
    del val_ood_image_idxs, val_ood_labels

    test_ood_image_idxs, test_ood_labels = get_image_idxs_and_labels('test', args.data_dir)
    for year in range(14, 17):
        datasets[year] = {}
        datasets[year][Mode.TRAIN] = {}
        datasets[year][Mode.TEST_ID] = {}
        datasets[year][Mode.TEST_OOD] = {}

        train_image_idxs, train_labels, test_image_idxs, test_labels = get_train_test_split(test_ood_image_idxs[year][0], test_ood_labels[year][0])
        datasets[year][Mode.TRAIN]['image_idxs'] = train_image_idxs
        datasets[year][Mode.TRAIN]['labels'] = train_labels
        datasets[year][Mode.TEST_ID]['image_idxs'] = test_image_idxs
        datasets[year][Mode.TEST_ID]['labels'] = test_labels
        datasets[year][Mode.TEST_OOD]['image_idxs'] = test_ood_image_idxs[year][0]
        datasets[year][Mode.TEST_OOD]['labels'] = test_ood_labels[year][0]
        del train_image_idxs, train_labels, test_image_idxs, test_labels
    del test_ood_image_idxs, test_ood_labels

    print(datasets)
    # for split in ['train', 'val', 'id_test', 'ood_val', 'test']:
    #     split_mask = split_array == split_dict[split]
    #     split_idx = np.where(split_mask)[0]
    #     y_array.append(dataset.y_array[split_idx])
    #     years = dataset.metadata_array[split_idx, 1]
    #     split_unique_years = torch.unique(years).detach().numpy().tolist()
    #     print(split, split_unique_years)
    #
    #     for year in split_unique_years:
    #         image_idxs_all = []
    #         labels_all = []
    #         image_idxs_all.append(dataset.full_idxs[split_idx][torch.where(years == year)])
    #         labels_all.append(dataset.y_array[split_idx][torch.where(years == year)])
    #
    #         if year not in datasets.keys():
    #             datasets[year] = {}
    #             datasets[year][Mode.TRAIN] = {}
    #             datasets[year][Mode.TEST_ID] = {}
    #             datasets[year][Mode.TEST_OOD] = {}
    #         if split == 'train':
    #             train_image_idxs, train_labels = [], []
    #             train_image_idxs.append(dataset.full_idxs[split_idx][torch.where(years == year)])
    #             train_labels.append(dataset.y_array[split_idx][torch.where(years == year)])
    #         elif split == 'val':
    #             train_image_idxs.append(dataset.full_idxs[split_idx][torch.where(years == year)])
    #             train_labels.append(dataset.y_array[split_idx][torch.where(years == year)])
    #             datasets[year][Mode.TRAIN]['image_idxs'] = np.concatenate(train_image_idxs, axis=0)
    #             datasets[year][Mode.TRAIN]['labels'] = np.concatenate(train_labels, axis=0)
    #         elif split == 'id_test':
    #             datasets[year][Mode.TEST_ID]['image_idxs']= dataset.full_idxs[split_idx][torch.where(years == year)]
    #             datasets[year][Mode.TEST_ID]['labels'] = dataset.y_array[split_idx][torch.where(years == year)]
    #         elif split == 'ood_val':
    #             datasets[year][Mode.TEST_OOD]['image_idxs'] = dataset.full_idxs[split_idx][torch.where(years == year)]
    #             datasets[year][Mode.TEST_OOD]['labels'] = dataset.y_array[split_idx][torch.where(years == year)]
    #         elif split == 'test':
    #             datasets[year][Mode.TEST_OOD]['image_idxs'] = dataset.full_idxs[split_idx][torch.where(years == year)]
    #             datasets[year][Mode.TEST_OOD]['labels'] = dataset.y_array[split_idx][torch.where(years == year)]
    #
    #     unique_years = unique_years + split_unique_years
    #
    # for year in sorted(unique_years):
    #     if year not in datasets.keys():
    #         datasets[year] = {}
    #         datasets[year][Mode.TRAIN] = {}
    #         datasets[year][Mode.TRAIN]['image_idxs'] = []
    #         datasets[year][Mode.TRAIN]['labels'] = []
    #         datasets[year][Mode.TEST_ID] = {}
    #         datasets[year][Mode.TEST_ID]['image_idxs'] = []
    #         datasets[year][Mode.TEST_ID]['labels'] = []
    #         datasets[year][Mode.TEST_OOD] = {}
    #         datasets[year][Mode.TEST_OOD]['image_idxs'] = []
    #         datasets[year][Mode.TEST_OOD]['labels'] = []
    #
    #     image_idxs_year = np.concatenate(image_idxs[year], axis=0)
    #     labels_year = np.concatenate(labels[year], axis=0)
    #     num_samples = len(labels_year)
    #     num_train_samples = int((1 - ID_HELD_OUT) * num_samples)
    #     seed_ = np.random.get_state()
    #     np.random.seed(0)
    #     idxs = np.random.permutation(np.arange(num_samples))
    #     np.random.set_state(seed_)
    #     train_image_idxs = image_idxs_year[idxs[:num_train_samples]]
    #     train_labels = labels_year[idxs[:num_train_samples]]
    #     test_image_idxs = image_idxs_year[idxs[num_train_samples:]]
    #     test_labels = labels_year[idxs[num_train_samples:]]
    #     datasets[year][Mode.TRAIN]['image_idxs'] = train_image_idxs
    #     datasets[year][Mode.TRAIN]['labels'] = train_labels
    #     datasets[year][Mode.TEST_ID]['image_idxs'] = test_image_idxs
    #     datasets[year][Mode.TEST_ID]['labels'] = test_labels
    #     datasets[year][Mode.TEST_OOD]['image_idxs'] = image_idxs_year
    #     datasets[year][Mode.TEST_OOD]['labels'] = labels_year
    #     del image_idxs_year, labels_year, train_image_idxs, train_labels, test_image_idxs, test_labels

    preprocessed_data_path = os.path.join(args.data_dir, 'fmow.pkl')
    pickle.dump(datasets, open(preprocessed_data_path, 'wb'))