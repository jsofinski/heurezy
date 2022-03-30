import plotly.express as px
import pandas as pd

df = pd.read_csv("test2optNeighboursAsCalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgTime", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres1.png")
fig = px.line(df, x="numberOfNodes", y="minTime", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres2.png")
fig = px.line(df, x="numberOfNodes", y="maxTime", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres3.png")


df = pd.read_csv("test2optNeighboursSCalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgTime", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres4.png")
fig = px.line(df, x="numberOfNodes", y="minTime", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres5.png")
fig = px.line(df, x="numberOfNodes", y="maxTime", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres6.png")

df = pd.read_csv("test2optNeighboursECalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgTime", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres7.png")
fig = px.line(df, x="numberOfNodes", y="minTime", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres8.png")
fig = px.line(df, x="numberOfNodes", y="maxTime", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres9.png")

df = pd.read_csv("test2optNeighboursAsCalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgWeight", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres10.png")
fig = px.line(df, x="numberOfNodes", y="minWeight", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres11.png")
fig = px.line(df, x="numberOfNodes", y="maxWeight", color="alg", title="Neighbours Comparison Asymmetrical")
fig.write_image("wykres12.png")


df = pd.read_csv("test2optNeighboursSCalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgWeight", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres13.png")
fig = px.line(df, x="numberOfNodes", y="minWeight", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres14.png")
fig = px.line(df, x="numberOfNodes", y="maxWeight", color="alg", title="Neighbours Comparison Symmetrical")
fig.write_image("wykres15.png")

df = pd.read_csv("test2optNeighboursECalc.csv", sep=";")
fig = px.line(df, x="numberOfNodes", y="avgWeight", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres16.png")
fig = px.line(df, x="numberOfNodes", y="minWeight", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres17.png")
fig = px.line(df, x="numberOfNodes", y="maxWeight", color="alg", title="Neighbours Comparison Euclidian")
fig.write_image("wykres18.png")
