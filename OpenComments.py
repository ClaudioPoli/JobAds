import pandas as pd

mixbag = pd.read_csv('C:/Users/Public/Benefits/Comments/MixedBag.csv', encoding='latin1')
mixbag.to_csv(r'C:/Users/Public/Benefits/Comments/MixedBag.csv', index=False)
