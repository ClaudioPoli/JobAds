import pandas as pd


def clean(folder, name):
    df = pd.read_csv('C:/Users/Public/' + folder + '/' + name + '.csv',encoding='latin1')
    df = (df.drop(df.index[0]))
    df.to_csv(r'C:/Users/Public/' + folder + '/' + name + '.csv', index=False)

clean('JobDesctiption', 'TfIdf')
clean('JobDesctiption', 'Hyponymy')
clean('JobDesctiption', 'Annotation')

